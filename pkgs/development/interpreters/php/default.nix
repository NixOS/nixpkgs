# pcre functionality is tested in nixos/tests/php-pcre.nix
{ config, lib, stdenv, fetchurl
, autoconf, automake, bison, file, flex, libtool, pkgconfig, re2c
, libxml2, readline, zlib, curl, postgresql, gettext
, openssl, pcre, pcre2, sqlite
, libxslt, bzip2, icu, openldap, cyrus_sasl, unixODBC
, uwimap, pam, gmp, apacheHttpd, libiconv, systemd, libsodium, html-tidy, libargon2
, gd, freetype, libXpm, libjpeg, libpng, libwebp
, libzip, valgrind, oniguruma, symlinkJoin, writeText
, makeWrapper, callPackage
}:

let
  generic =
  { version
  , sha256
  , extraPatches ? []
  , withSystemd ? config.php.systemd or stdenv.isLinux
  , imapSupport ? config.php.imap or (!stdenv.isDarwin)
  , ldapSupport ? config.php.ldap or true
  , mysqlndSupport ? config.php.mysqlnd or true
  , mysqliSupport ? (config.php.mysqli or true) && (mysqlndSupport)
  , pdo_mysqlSupport ? (config.php.pdo_mysql or true) && (mysqlndSupport)
  , libxml2Support ? config.php.libxml2 or true
  , apxs2Support ? config.php.apxs2 or (!stdenv.isDarwin)
  , embedSupport ? config.php.embed or false
  , bcmathSupport ? config.php.bcmath or true
  , socketsSupport ? config.php.sockets or true
  , curlSupport ? config.php.curl or true
  , gettextSupport ? config.php.gettext or true
  , pcntlSupport ? config.php.pcntl or true
  , pdo_odbcSupport ? config.php.pdo_odbc or true
  , postgresqlSupport ? config.php.postgresql or true
  , pdo_pgsqlSupport ? config.php.pdo_pgsql or true
  , readlineSupport ? config.php.readline or true
  , sqliteSupport ? config.php.sqlite or true
  , soapSupport ? (config.php.soap or true) && (libxml2Support)
  , zlibSupport ? config.php.zlib or true
  , opensslSupport ? config.php.openssl or true
  , mbstringSupport ? config.php.mbstring or true
  , gdSupport ? config.php.gd or true
  , intlSupport ? config.php.intl or true
  , exifSupport ? config.php.exif or true
  , xslSupport ? config.php.xsl or false
  , bz2Support ? config.php.bz2 or false
  , zipSupport ? config.php.zip or true
  , ftpSupport ? config.php.ftp or true
  , fpmSupport ? config.php.fpm or true
  , gmpSupport ? config.php.gmp or true
  , ztsSupport ? (config.php.zts or false) || (apxs2Support)
  , calendarSupport ? config.php.calendar or true
  , sodiumSupport ? (config.php.sodium or true) && (lib.versionAtLeast version "7.2")
  , tidySupport ? (config.php.tidy or false)
  , argon2Support ? (config.php.argon2 or true) && (lib.versionAtLeast version "7.2")
  , libzipSupport ? (config.php.libzip or true) && (lib.versionAtLeast version "7.2")
  , phpdbgSupport ? config.php.phpdbg or true
  , cgiSupport ? config.php.cgi or true
  , cliSupport ? config.php.cli or true
  , pharSupport ? config.php.phar or true
  , xmlrpcSupport ? (config.php.xmlrpc or false) && (libxml2Support)
  , cgotoSupport ? config.php.cgoto or false
  , valgrindSupport ? (config.php.valgrind or true) && (lib.versionAtLeast version "7.2")
  , ipv6Support ? config.php.ipv6 or true
  , pearSupport ? (config.php.pear or true) && (libxml2Support)
  }: stdenv.mkDerivation {
    pname = "php";

    inherit version;

    enableParallelBuilding = true;

    nativeBuildInputs = [ autoconf automake bison file flex libtool pkgconfig re2c ];

    buildInputs = [ ]
      ++ lib.optional (lib.versionOlder version "7.3") pcre
      ++ lib.optional (lib.versionAtLeast version "7.3") pcre2
      ++ lib.optional (lib.versionAtLeast version "7.4") oniguruma
      ++ lib.optional withSystemd systemd
      ++ lib.optionals imapSupport [ uwimap openssl pam ]
      ++ lib.optionals curlSupport [ curl openssl ]
      ++ lib.optionals ldapSupport [ openldap openssl ]
      ++ lib.optionals gdSupport [ gd freetype libXpm libjpeg libpng libwebp ]
      ++ lib.optionals opensslSupport [ openssl openssl.dev ]
      ++ lib.optional apxs2Support apacheHttpd
      ++ lib.optional (ldapSupport && stdenv.isLinux) cyrus_sasl
      ++ lib.optional zlibSupport zlib
      ++ lib.optional libxml2Support libxml2
      ++ lib.optional readlineSupport readline
      ++ lib.optional sqliteSupport sqlite
      ++ lib.optional postgresqlSupport postgresql
      ++ lib.optional pdo_odbcSupport unixODBC
      ++ lib.optional pdo_pgsqlSupport postgresql
      ++ lib.optional gmpSupport gmp
      ++ lib.optional gettextSupport gettext
      ++ lib.optional intlSupport icu
      ++ lib.optional xslSupport libxslt
      ++ lib.optional bz2Support bzip2
      ++ lib.optional sodiumSupport libsodium
      ++ lib.optional tidySupport html-tidy
      ++ lib.optional argon2Support libargon2
      ++ lib.optional libzipSupport libzip
      ++ lib.optional valgrindSupport valgrind;

    CXXFLAGS = lib.optionalString stdenv.cc.isClang "-std=c++11";

    configureFlags = [ "--with-config-file-scan-dir=/etc/php.d" ]
      ++ lib.optionals (lib.versionOlder version "7.3") [ "--with-pcre-regex=${pcre.dev}" "PCRE_LIBDIR=${pcre}" ]
      ++ lib.optionals (lib.versions.majorMinor version == "7.3") [ "--with-pcre-regex=${pcre2.dev}" "PCRE_LIBDIR=${pcre2}" ]
      ++ lib.optionals (lib.versionAtLeast version "7.4") [ "--with-external-pcre=${pcre2.dev}" "PCRE_LIBDIR=${pcre2}" ]
      ++ lib.optional stdenv.isDarwin "--with-iconv=${libiconv}"
      ++ lib.optional withSystemd "--with-fpm-systemd"
      ++ lib.optionals imapSupport [
        "--with-imap=${uwimap}"
        "--with-imap-ssl"
      ]
      ++ lib.optionals ldapSupport [
        "--with-ldap=/invalid/path"
        "LDAP_DIR=${openldap.dev}"
        "LDAP_INCDIR=${openldap.dev}/include"
        "LDAP_LIBDIR=${openldap.out}/lib"
      ]
      ++ lib.optional (ldapSupport && stdenv.isLinux) "--with-ldap-sasl=${cyrus_sasl.dev}"
      ++ lib.optional apxs2Support "--with-apxs2=${apacheHttpd.dev}/bin/apxs"
      ++ lib.optional embedSupport "--enable-embed"
      ++ lib.optional curlSupport "--with-curl=${curl.dev}"
      ++ lib.optional zlibSupport "--with-zlib=${zlib.dev}"
      ++ lib.optional (libxml2Support && (lib.versionOlder version "7.4")) "--with-libxml-dir=${libxml2.dev}"
      ++ lib.optional (!libxml2Support) [
        "--disable-dom"
        (if (lib.versionOlder version "7.4") then "--disable-libxml" else "--without-libxml")
        "--disable-simplexml"
        "--disable-xml"
        "--disable-xmlreader"
        "--disable-xmlwriter"
        "--without-pear"
      ]
      ++ lib.optional pcntlSupport "--enable-pcntl"
      ++ lib.optional readlineSupport "--with-readline=${readline.dev}"
      ++ lib.optional sqliteSupport "--with-pdo-sqlite=${sqlite.dev}"
      ++ lib.optional postgresqlSupport "--with-pgsql=${postgresql}"
      ++ lib.optional pdo_odbcSupport "--with-pdo-odbc=unixODBC,${unixODBC}"
      ++ lib.optional pdo_pgsqlSupport "--with-pdo-pgsql=${postgresql}"
      ++ lib.optional (pdo_mysqlSupport && mysqlndSupport) "--with-pdo-mysql=mysqlnd"
      ++ lib.optional (mysqliSupport && mysqlndSupport) "--with-mysqli=mysqlnd"
      ++ lib.optional (pdo_mysqlSupport || mysqliSupport) "--with-mysql-sock=/run/mysqld/mysqld.sock"
      ++ lib.optional bcmathSupport "--enable-bcmath"
      ++ lib.optionals (gdSupport && lib.versionAtLeast version "7.4") [
        "--enable-gd"
        "--with-external-gd=${gd.dev}"
        "--with-webp=${libwebp}"
        "--with-jpeg=${libjpeg.dev}"
        "--with-xpm=${libXpm.dev}"
        "--with-freetype=${freetype.dev}"
        "--enable-gd-jis-conv"
      ] ++ lib.optionals (gdSupport && lib.versionOlder version "7.4") [
        "--with-gd=${gd.dev}"
        "--with-webp-dir=${libwebp}"
        "--with-jpeg-dir=${libjpeg.dev}"
        "--with-png-dir=${libpng.dev}"
        "--with-freetype-dir=${freetype.dev}"
        "--with-xpm-dir=${libXpm.dev}"
        "--enable-gd-jis-conv"
      ]
      ++ lib.optional gmpSupport "--with-gmp=${gmp.dev}"
      ++ lib.optional soapSupport "--enable-soap"
      ++ lib.optional socketsSupport "--enable-sockets"
      ++ lib.optional opensslSupport "--with-openssl"
      ++ lib.optional mbstringSupport "--enable-mbstring"
      ++ lib.optional gettextSupport "--with-gettext=${gettext}"
      ++ lib.optional intlSupport "--enable-intl"
      ++ lib.optional exifSupport "--enable-exif"
      ++ lib.optional xslSupport "--with-xsl=${libxslt.dev}"
      ++ lib.optional bz2Support "--with-bz2=${bzip2.dev}"
      ++ lib.optional (zipSupport && (lib.versionOlder version "7.4")) "--enable-zip"
      ++ lib.optional (zipSupport && (lib.versionAtLeast version "7.4")) "--with-zip"
      ++ lib.optional ftpSupport "--enable-ftp"
      ++ lib.optional fpmSupport "--enable-fpm"
      ++ lib.optional ztsSupport "--enable-maintainer-zts"
      ++ lib.optional calendarSupport "--enable-calendar"
      ++ lib.optional sodiumSupport "--with-sodium=${libsodium.dev}"
      ++ lib.optional tidySupport "--with-tidy=${html-tidy}"
      ++ lib.optional argon2Support "--with-password-argon2=${libargon2}"
      ++ lib.optional (libzipSupport && (lib.versionOlder version "7.4")) "--with-libzip=${libzip.dev}"
      ++ lib.optional phpdbgSupport "--enable-phpdbg"
      ++ lib.optional (!phpdbgSupport) "--disable-phpdbg"
      ++ lib.optional (!cgiSupport) "--disable-cgi"
      ++ lib.optional (!cliSupport) "--disable-cli"
      ++ lib.optional (!pharSupport) "--disable-phar"
      ++ lib.optional xmlrpcSupport "--with-xmlrpc"
      ++ lib.optional cgotoSupport "--enable-re2c-cgoto"
      ++ lib.optional valgrindSupport "--with-valgrind=${valgrind.dev}"
      ++ lib.optional (!ipv6Support) "--disable-ipv6"
      ++ lib.optional (pearSupport && libxml2Support) "--with-pear=$(out)/lib/php/pear";

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

      substituteInPlace ./build/libtool.m4 --replace /usr/bin/file ${file}/bin/file

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

    meta = with stdenv.lib; {
      description = "An HTML-embedded scripting language";
      homepage = "https://www.php.net/";
      license = licenses.php301;
      maintainers = with maintainers; [ globin etu ma27 ];
      platforms = platforms.all;
      outputsToInstall = [ "out" "dev" ];
    };

    patches = [ ./fix-paths-php7.patch ] ++ extraPatches;

    stripDebugList = "bin sbin lib modules";

    outputs = [ "out" "dev" ];
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
