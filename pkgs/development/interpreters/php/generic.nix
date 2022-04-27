# We have tests for PCRE and PHP-FPM in nixos/tests/php/ or
# both in the same attribute named nixosTests.php

let
  generic =
    { callPackage
    , lib
    , stdenv
    , nixosTests
    , tests
    , fetchurl
    , makeWrapper
    , symlinkJoin
    , writeText
    , autoconf
    , automake
    , bison
    , flex
    , libtool
    , pkg-config
    , re2c
    , apacheHttpd
    , libargon2
    , libxml2
    , pcre2
    , systemd
    , system-sendmail
    , valgrind
    , xcbuild

    , version
    , sha256
    , extraPatches ? [ ]
    , packageOverrides ? (final: prev: { })
    , phpAttrsOverrides ? (attrs: { })

      # Sapi flags
    , cgiSupport ? true
    , cliSupport ? true
    , fpmSupport ? true
    , pearSupport ? true
    , pharSupport ? true
    , phpdbgSupport ? true

      # Misc flags
    , apxs2Support ? !stdenv.isDarwin
    , argon2Support ? true
    , cgotoSupport ? false
    , embedSupport ? false
    , ipv6Support ? true
    , systemdSupport ? stdenv.isLinux
    , valgrindSupport ? !stdenv.isDarwin && lib.meta.availableOn stdenv.hostPlatform valgrind
    , ztsSupport ? apxs2Support
    }@args:

    let
      # Compose two functions of the type expected by 'overrideAttrs'
      # into one where changes made in the first are available to the second.
      composeOverrides =
        f: g: attrs:
        let
          fApplied = f attrs;
          attrs' = attrs // fApplied;
        in
        fApplied // g attrs';

      # buildEnv wraps php to provide additional extensions and
      # configuration. Its usage is documented in
      # doc/languages-frameworks/php.section.md.
      #
      # Create a buildEnv with earlier overridden values and
      # extensions functions in its closure. This is necessary for
      # consecutive calls to buildEnv and overrides to work as
      # expected.
      mkBuildEnv = prevArgs: prevExtensionFunctions: lib.makeOverridable (
        { extensions ? ({ enabled, ... }: enabled), extraConfig ? "", ... }@innerArgs:
        let
          allArgs = args // prevArgs // innerArgs;
          filteredArgs = builtins.removeAttrs allArgs [ "extensions" "extraConfig" ];
          php = generic filteredArgs;

          php-packages = (callPackage ../../../top-level/php-packages.nix {
            phpPackage = phpWithExtensions;
          }).overrideScope' packageOverrides;

          allExtensionFunctions = prevExtensionFunctions ++ [ extensions ];
          enabledExtensions =
            builtins.foldl'
              (enabled: f:
                f { inherit enabled; all = php-packages.extensions; })
              [ ]
              allExtensionFunctions;

          getExtName = ext: lib.removePrefix "php-" (builtins.parseDrvName ext.name).name;

          # Recursively get a list of all internal dependencies
          # for a list of extensions.
          getDepsRecursively = extensions:
            let
              deps = lib.concatMap
                (ext: (ext.internalDeps or [ ]) ++ (ext.peclDeps or [ ]))
                extensions;
            in
            if ! (deps == [ ]) then
              deps ++ (getDepsRecursively deps)
            else
              deps;

          # Generate extension load configuration snippets from the
          # extension parameter. This is an attrset suitable for use
          # with textClosureList, which is used to put the strings in
          # the right order - if a plugin which is dependent on
          # another plugin is placed before its dependency, it will
          # fail to load.
          extensionTexts =
            lib.listToAttrs
              (map
                (ext:
                  let
                    extName = getExtName ext;
                    phpDeps = (ext.internalDeps or [ ]) ++ (ext.peclDeps or [ ]);
                    type = "${lib.optionalString (ext.zendExtension or false) "zend_"}extension";
                  in
                  lib.nameValuePair extName {
                    text = "${type}=${ext}/lib/php/extensions/${extName}.so";
                    deps = map getExtName phpDeps;
                  })
                (enabledExtensions ++ (getDepsRecursively enabledExtensions)));

          extNames = map getExtName enabledExtensions;
          extraInit = writeText "php-extra-init-${version}.ini" ''
            ${lib.concatStringsSep "\n"
              (lib.textClosureList extensionTexts extNames)}
            ${extraConfig}
          '';

          phpWithExtensions = symlinkJoin {
            name = "php-with-extensions-${version}";
            inherit (php) version;
            nativeBuildInputs = [ makeWrapper ];
            passthru = php.passthru // {
              buildEnv = mkBuildEnv allArgs allExtensionFunctions;
              withExtensions = mkWithExtensions allArgs allExtensionFunctions;
              overrideAttrs =
                f:
                let
                  newPhpAttrsOverrides = composeOverrides (filteredArgs.phpAttrsOverrides or (attrs: { })) f;
                  php = generic (filteredArgs // { phpAttrsOverrides = newPhpAttrsOverrides; });
                in
                php.buildEnv { inherit extensions extraConfig; };
              phpIni = "${phpWithExtensions}/lib/php.ini";
              unwrapped = php;
              # Select the right php tests for the php version
              tests = {
                nixos = lib.recurseIntoAttrs nixosTests."php${lib.strings.replaceStrings [ "." ] [ "" ] (lib.versions.majorMinor php.version)}";
                package = tests.php;
              };
              inherit (php-packages) extensions buildPecl mkExtension;
              packages = php-packages.tools;
              meta = php.meta // {
                outputsToInstall = [ "out" ];
              };
            };
            paths = [ php ];
            postBuild = ''
              ln -s ${extraInit} $out/lib/php.ini

              if test -e $out/bin/php; then
                wrapProgram $out/bin/php --set PHP_INI_SCAN_DIR $out/lib
              fi

              if test -e $out/bin/php-fpm; then
                wrapProgram $out/bin/php-fpm --set PHP_INI_SCAN_DIR $out/lib
              fi

              if test -e $out/bin/phpdbg; then
                wrapProgram $out/bin/phpdbg --set PHP_INI_SCAN_DIR $out/lib
              fi

              if test -e $out/bin/php-cgi; then
                wrapProgram $out/bin/php-cgi --set PHP_INI_SCAN_DIR $out/lib
              fi
            '';
          };
        in
        phpWithExtensions
      );

      mkWithExtensions = prevArgs: prevExtensionFunctions: extensions:
        mkBuildEnv prevArgs prevExtensionFunctions { inherit extensions; };
    in
    stdenv.mkDerivation (
      let
        attrs = {
          pname = "php";

          inherit version;

          enableParallelBuilding = true;

          nativeBuildInputs = [ autoconf automake bison flex libtool pkg-config re2c ]
            ++ lib.optional stdenv.isDarwin xcbuild;

          buildInputs =
            # PCRE extension
            [ pcre2 ]

            # Enable sapis
            ++ lib.optional pearSupport [ libxml2.dev ]

            # Misc deps
            ++ lib.optional apxs2Support apacheHttpd
            ++ lib.optional argon2Support libargon2
            ++ lib.optional systemdSupport systemd
            ++ lib.optional valgrindSupport valgrind
          ;

          CXXFLAGS = lib.optionalString stdenv.cc.isClang "-std=c++11";
          SKIP_PERF_SENSITIVE = 1;

          configureFlags =
            # Disable all extensions
            [ "--disable-all" ]

            # PCRE
            ++ lib.optionals (lib.versionAtLeast version "7.4") [ "--with-external-pcre=${pcre2.dev}" ]
            ++ [ "PCRE_LIBDIR=${pcre2}" ]


            # Enable sapis
            ++ lib.optional (!cgiSupport) "--disable-cgi"
            ++ lib.optional (!cliSupport) "--disable-cli"
            ++ lib.optional fpmSupport "--enable-fpm"
            ++ lib.optional pearSupport [ "--with-pear" "--enable-xml" "--with-libxml" ]
            ++ lib.optionals (pearSupport && (lib.versionOlder version "7.4")) [
              "--enable-libxml"
              "--with-libxml-dir=${libxml2.dev}"
            ]
            ++ lib.optional pharSupport "--enable-phar"
            ++ lib.optional (!phpdbgSupport) "--disable-phpdbg"


            # Misc flags
            ++ lib.optional apxs2Support "--with-apxs2=${apacheHttpd.dev}/bin/apxs"
            ++ lib.optional argon2Support "--with-password-argon2=${libargon2}"
            ++ lib.optional cgotoSupport "--enable-re2c-cgoto"
            ++ lib.optional embedSupport "--enable-embed"
            ++ lib.optional (!ipv6Support) "--disable-ipv6"
            ++ lib.optional systemdSupport "--with-fpm-systemd"
            ++ lib.optional valgrindSupport "--with-valgrind=${valgrind.dev}"
            ++ lib.optional (ztsSupport && (lib.versionOlder version "8.0")) "--enable-maintainer-zts"
            ++ lib.optional (ztsSupport && (lib.versionAtLeast version "8.0")) "--enable-zts"


            # Sendmail
            ++ [ "PROG_SENDMAIL=${system-sendmail}/bin/sendmail" ]
          ;

          hardeningDisable = [ "bindnow" ];

          preConfigure =
            # Don't record the configure flags since this causes unnecessary
            # runtime dependencies
            ''
              for i in main/build-defs.h.in scripts/php-config.in; do
                substituteInPlace $i \
                  --replace '@CONFIGURE_COMMAND@' '(omitted)' \
                  --replace '@CONFIGURE_OPTIONS@' "" \
                  --replace '@PHP_LDFLAGS@' ""
              done

              export EXTENSION_DIR=$out/lib/php/extensions
            ''
            # PKG_CONFIG need not be a relative path
            + lib.optionalString (lib.versionOlder version "7.4") ''
              for i in $(find . -type f -name "*.m4"); do
                substituteInPlace $i \
                  --replace 'test -x "$PKG_CONFIG"' 'type -P "$PKG_CONFIG" >/dev/null'
              done
            '' + ''
              ./buildconf --copy --force

              if test -f $src/genfiles; then
                ./genfiles
              fi
            '' + lib.optionalString stdenv.isDarwin ''
              substituteInPlace configure --replace "-lstdc++" "-lc++"
            '';

          postInstall = ''
            test -d $out/etc || mkdir $out/etc
            cp php.ini-production $out/etc/php.ini
          '';

          postFixup = ''
            mkdir -p $dev/bin $dev/share/man/man1
            mv $out/bin/phpize $out/bin/php-config $dev/bin/
            mv $out/share/man/man1/phpize.1.gz \
               $out/share/man/man1/php-config.1.gz \
               $dev/share/man/man1/
          '';

          src = fetchurl {
            url = "https://www.php.net/distributions/php-${version}.tar.bz2";
            inherit sha256;
          };

          patches = [ ./fix-paths-php7.patch ] ++ extraPatches;

          separateDebugInfo = true;

          outputs = [ "out" "dev" ];

          passthru = {
            buildEnv = mkBuildEnv { } [ ];
            withExtensions = mkWithExtensions { } [ ];
            overrideAttrs =
              f:
              let
                newPhpAttrsOverrides = composeOverrides phpAttrsOverrides f;
                php = generic (args // { phpAttrsOverrides = newPhpAttrsOverrides; });
              in
              php;
            inherit ztsSupport;
          };

          meta = with lib; {
            description = "An HTML-embedded scripting language";
            homepage = "https://www.php.net/";
            license = licenses.php301;
            maintainers = teams.php.members;
            platforms = platforms.all;
            outputsToInstall = [ "out" "dev" ];
          };
        };
      in
      attrs // phpAttrsOverrides attrs
    );
in
generic
