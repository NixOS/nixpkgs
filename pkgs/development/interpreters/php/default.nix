# We have tests for PCRE and PHP-FPM in nixos/tests/php/ or
# both in the same attribute named nixosTests.php

{ callPackage, lib, stdenv, nixosTests }@_args:

let
  generic =
    { callPackage, lib, stdenv, nixosTests, config, fetchurl, makeWrapper
    , symlinkJoin, writeText, autoconf, automake, bison, flex, libtool
    , pkgconfig, re2c, apacheHttpd, libargon2, libxml2, pcre, pcre2
    , systemd, system-sendmail, valgrind, xcbuild

    , version
    , sha256
    , extraPatches ? []

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
    , valgrindSupport ? true
    , ztsSupport ? apxs2Support
    }@args:
      let
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
                php = phpWithExtensions;
              });

              allExtensionFunctions = prevExtensionFunctions ++ [ extensions ];
              enabledExtensions =
                builtins.foldl'
                  (enabled: f:
                    f { inherit enabled; all = php-packages.extensions; })
                  []
                  allExtensionFunctions;

              getExtName = ext: lib.removePrefix "php-" (builtins.parseDrvName ext.name).name;

              # Recursively get a list of all internal dependencies
              # for a list of extensions.
              getDepsRecursively = extensions:
                let
                  deps = lib.concatMap
                           (ext: (ext.internalDeps or []) ++ (ext.peclDeps or []))
                           extensions;
                in
                  if ! (deps == []) then
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
                  (map (ext:
                    let
                      extName = getExtName ext;
                      phpDeps = (ext.internalDeps or []) ++ (ext.peclDeps or []);
                      type = "${lib.optionalString (ext.zendExtension or false) "zend_"}extension";
                    in
                      lib.nameValuePair extName {
                        text = "${type}=${ext}/lib/php/extensions/${extName}.so";
                        deps = map getExtName phpDeps;
                      })
                    (enabledExtensions ++ (getDepsRecursively enabledExtensions)));

              extNames = map getExtName enabledExtensions;
              extraInit = writeText "php.ini" ''
                ${lib.concatStringsSep "\n"
                  (lib.textClosureList extensionTexts extNames)}
                ${extraConfig}
              '';

              phpWithExtensions = symlinkJoin rec {
                name = "php-with-extensions-${version}";
                inherit (php) version;
                nativeBuildInputs = [ makeWrapper ];
                passthru = {
                  buildEnv = mkBuildEnv allArgs allExtensionFunctions;
                  withExtensions = mkWithExtensions allArgs allExtensionFunctions;
                  phpIni = "${phpWithExtensions}/lib/php.ini";
                  unwrapped = php;
                  tests = nixosTests.php;
                  inherit (php-packages) packages extensions buildPecl;
                  meta = php.meta // {
                    outputsToInstall = [ "out" ];
                  };
                };
                paths = [ php ];
                postBuild = ''
                  cp ${extraInit} $out/lib/php.ini

                  wrapProgram $out/bin/php --set PHP_INI_SCAN_DIR $out/lib

                  if test -e $out/bin/php-fpm; then
                    wrapProgram $out/bin/php-fpm --set PHP_INI_SCAN_DIR $out/lib
                  fi
                '';
              };
            in
              phpWithExtensions);

        mkWithExtensions = prevArgs: prevExtensionFunctions: extensions:
          mkBuildEnv prevArgs prevExtensionFunctions { inherit extensions; };

        pcre' = if (lib.versionAtLeast version "7.3") then pcre2 else pcre;
      in
        stdenv.mkDerivation {
          pname = "php";

          inherit version;

          enableParallelBuilding = true;

          nativeBuildInputs = [ autoconf automake bison flex libtool pkgconfig re2c ]
            ++ lib.optional stdenv.isDarwin xcbuild;

          buildInputs =
            # PCRE extension
            [ pcre' ]

            # Enable sapis
            ++ lib.optional pearSupport [ libxml2.dev ]

            # Misc deps
            ++ lib.optional apxs2Support apacheHttpd
            ++ lib.optional argon2Support libargon2
            ++ lib.optional systemdSupport systemd
            ++ lib.optional valgrindSupport valgrind
          ;

          CXXFLAGS = lib.optionalString stdenv.cc.isClang "-std=c++11";

          configureFlags =
            # Disable all extensions
            [ "--disable-all" ]

            # PCRE
            ++ lib.optionals (lib.versionAtLeast version "7.4") [ "--with-external-pcre=${pcre'.dev}" ]
            ++ lib.optionals (lib.versions.majorMinor version == "7.3") [ "--with-pcre-regex=${pcre'.dev}" ]
            ++ lib.optionals (lib.versionOlder version "7.3") [ "--with-pcre-regex=${pcre'.dev}" ]
            ++ [ "PCRE_LIBDIR=${pcre'}" ]


            # Enable sapis
            ++ lib.optional (!cgiSupport) "--disable-cgi"
            ++ lib.optional (!cliSupport) "--disable-cli"
            ++ lib.optional fpmSupport    "--enable-fpm"
            ++ lib.optional pearSupport [ "--with-pear=$(out)/lib/php/pear" "--enable-xml" "--with-libxml" ]
            ++ lib.optionals (pearSupport && (lib.versionOlder version "7.4")) [
              "--enable-libxml"
              "--with-libxml-dir=${libxml2.dev}"
            ]
            ++ lib.optional pharSupport   "--enable-phar"
            ++ lib.optional phpdbgSupport "--enable-phpdbg"


            # Misc flags
            ++ lib.optional apxs2Support "--with-apxs2=${apacheHttpd.dev}/bin/apxs"
            ++ lib.optional argon2Support "--with-password-argon2=${libargon2}"
            ++ lib.optional cgotoSupport "--enable-re2c-cgoto"
            ++ lib.optional embedSupport "--enable-embed"
            ++ lib.optional (!ipv6Support) "--disable-ipv6"
            ++ lib.optional systemdSupport "--with-fpm-systemd"
            ++ lib.optional valgrindSupport "--with-valgrind=${valgrind.dev}"
            ++ lib.optional ztsSupport "--enable-maintainer-zts"


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
          + lib.optionalString (! lib.versionAtLeast version "7.4") ''
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
            buildEnv = mkBuildEnv {} [];
            withExtensions = mkWithExtensions {} [];
          };

          meta = with stdenv.lib; {
            description = "An HTML-embedded scripting language";
            homepage = "https://www.php.net/";
            license = licenses.php301;
            maintainers = teams.php.members;
            platforms = platforms.all;
            outputsToInstall = [ "out" "dev" ];
          };
        };

  php73base = callPackage generic (_args // {
    version = "7.3.23";
    sha256 = "0k600imsxm3r3qdv20ryqhvfmnkmjhvm2hcnqr180l058snncrpx";

    # https://bugs.php.net/bug.php?id=76826
    extraPatches = lib.optional stdenv.isDarwin ./php73-darwin-isfinite.patch;
  });

  php74base = callPackage generic (_args // {
    version = "7.4.11";
    sha256 = "1idq2sk3x6msy8l2g42jv3y87h1fgb1aybxw7wpjkliv4iaz422l";
  });

  defaultPhpExtensions = { all, ... }: with all; ([
    bcmath calendar curl ctype dom exif fileinfo filter ftp gd
    gettext gmp iconv intl json ldap mbstring mysqli mysqlnd opcache
    openssl pcntl pdo pdo_mysql pdo_odbc pdo_pgsql pdo_sqlite pgsql
    posix readline session simplexml sockets soap sodium sqlite3
    tokenizer xmlreader xmlwriter zip zlib
  ] ++ lib.optionals (!stdenv.isDarwin) [ imap ]);

  defaultPhpExtensionsWithHash = { all, ... }:
    (defaultPhpExtensions { inherit all; }) ++ [ all.hash ];

  php74 = php74base.withExtensions defaultPhpExtensions;
  php73 = php73base.withExtensions defaultPhpExtensionsWithHash;

in {
  inherit php73 php74;
}
