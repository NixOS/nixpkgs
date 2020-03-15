# pcre functionality is tested in nixos/tests/php-pcre.nix
{ callPackage, config, fetchurl, lib, makeWrapper, stdenv, symlinkJoin, writeText
, autoconf, automake, bison, flex, libtool, pkgconfig, re2c
, apacheHttpd, gettext, libargon2, libxml2, openssl, pcre, pcre2, readline
, sqlite, systemd, valgrind, zlib, oniguruma }:

let
  generic =
  { version
  , sha256
  , extraPatches ? []

  # Build a minimal php
  , minimalBuild ? config.php.minimal or false

  # Sapi flags
  , cgiSupport ? config.php.cgi or true
  , cliSupport ? config.php.cli or true
  , fpmSupport ? config.php.fpm or true
  , pearSupport ? config.php.pear or true
  , pharSupport ? config.php.phar or true
  , phpdbgSupport ? config.php.phpdbg or true


  # Misc flags
  , apxs2Support ? config.php.apxs2 or (!stdenv.isDarwin)
  , argon2Support ? config.php.argon2 or true
  , cgotoSupport ? config.php.cgoto or false
  , embedSupport ? config.php.embed or false
  , ipv6Support ? config.php.ipv6 or true
  , systemdSupport ? config.php.systemd or stdenv.isLinux
  , valgrindSupport ? config.php.valgrind or true
  , ztsSupport ? (config.php.zts or false) || (apxs2Support)
  }: let
    pcre' = if (lib.versionAtLeast version "7.3") then pcre2 else pcre;
  in stdenv.mkDerivation {
    pname = "php";

    inherit version;

    enableParallelBuilding = true;

    nativeBuildInputs = [ autoconf automake bison flex libtool pkgconfig re2c ];

    buildInputs = [ ]
      # Deps for some base extensions
      ++ [ gettext ]             # Gettext extension
      ++ [ openssl openssl.dev ] # Openssl extension
      ++ [ pcre' ]               # PCRE extension
      ++ [ readline ]            # Readline extension
      ++ [ zlib ]                # Zlib extension
      ++ [ oniguruma ]           # mbstring extension

      # Deps needed when building all default extensions
      ++ lib.optionals (!minimalBuild) [ sqlite ]

      # Enable sapis
      ++ lib.optional pearSupport [ libxml2.dev ]

      # Misc deps
      ++ lib.optional apxs2Support apacheHttpd
      ++ lib.optional argon2Support libargon2
      ++ lib.optional systemdSupport systemd
      ++ lib.optional valgrindSupport valgrind
    ;

    CXXFLAGS = lib.optionalString stdenv.cc.isClang "-std=c++11";

    configureFlags = []
      # Disable all extensions
      ++ lib.optional minimalBuild [ "--disable-all" ]

      # A bunch of base extensions
      ++ [ "--with-gettext=${gettext}" ]
      ++ [ "--with-openssl" ]
      ++ [ "--with-readline=${readline.dev}" ]
      ++ [ "--with-zlib=${zlib.dev}" ]
      ++ [ "--enable-mysqlnd" ] # Required to be able to build mysqli and pdo_mysql
      ++ [ "--enable-sockets" ]
      ++ [ "--enable-mbstring" ]

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
      ++ lib.optional (pearSupport && (lib.versionOlder version "7.4")) "--enable-libxml"
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
    ;

    hardeningDisable = [ "bindnow" ];

    preConfigure = ''
      # Don't record the configure flags since this causes unnecessary
      # runtime dependencies
      for i in main/build-defs.h.in scripts/php-config.in; do
        substituteInPlace $i \
          --replace '@CONFIGURE_COMMAND@' '(omitted)' \
          --replace '@CONFIGURE_OPTIONS@' "" \
          --replace '@PHP_LDFLAGS@' ""
      done

      export EXTENSION_DIR=$out/lib/php/extensions

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

    meta = with stdenv.lib; {
      description = "An HTML-embedded scripting language";
      homepage = "https://www.php.net/";
      license = licenses.php301;
      maintainers = with maintainers; [ globin etu ma27 ];
      platforms = platforms.all;
      outputsToInstall = [ "out" "dev" ];
    };
  };

  generic' = { version, sha256, ... }@args: let php = generic args; in php.overrideAttrs (_: {
    passthru.buildEnv = { exts ? (_: []), extraConfig ? "" }: let
      extraInit = writeText "custom-php.ini" ''
        ${extraConfig}
        ${lib.concatMapStringsSep "\n" (ext: let
          extName = lib.removePrefix "php-" (builtins.parseDrvName ext.name).name;
          type = "${lib.optionalString (ext.zendExtension or false) "zend_"}extension";
        in ''
          ${type}=${ext}/lib/php/extensions/${extName}.so
        '') (exts (callPackage ../../../top-level/php-packages.nix { inherit php; }))}
      '';
    in symlinkJoin {
      name = "php-custom-${version}";
      nativeBuildInputs = [ makeWrapper ];
      paths = [ php ];
      postBuild = ''
        wrapProgram $out/bin/php \
          --add-flags "-c ${extraInit}"
        wrapProgram $out/bin/php-fpm \
          --add-flags "-c ${extraInit}"
      '';
    };
  });

in {
  php72 = generic' {
    version = "7.2.28";
    sha256 = "18sjvl67z5a2x5s2a36g6ls1r3m4hbrsw52hqr2qsgfvg5dkm5bw";

    # https://bugs.php.net/bug.php?id=76826
    extraPatches = lib.optional stdenv.isDarwin ./php72-darwin-isfinite.patch;
  };

  php73 = generic' {
    version = "7.3.15";
    sha256 = "0g84hws15s8gh8iq4h6q747dyfazx47vh3da3whz8d80x83ibgld";

    # https://bugs.php.net/bug.php?id=76826
    extraPatches = lib.optional stdenv.isDarwin ./php73-darwin-isfinite.patch;
  };

  php74 = generic' {
    version = "7.4.3";
    sha256 = "wVF7pJV4+y3MZMc6Ptx21PxQfEp6xjmYFYTMfTtMbRQ=";
  };
}
