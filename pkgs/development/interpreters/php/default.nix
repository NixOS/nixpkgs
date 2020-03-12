# pcre functionality is tested in nixos/tests/php-pcre.nix
{ lib, stdenv, fetchurl, autoconf, bison, libtool, pkgconfig, re2c
, mysql, libxml2, readline, zlib, curl, postgresql, gettext
, openssl, pcre, pcre2, sqlite, config, libjpeg, libpng, freetype
, libxslt, libmcrypt, bzip2, icu, openldap, cyrus_sasl, libmhash, unixODBC
, uwimap, pam, gmp, apacheHttpd, libiconv, systemd, libsodium, html-tidy, libargon2
, libzip, valgrind
}:

with lib;

let
  generic =
  { version
  , sha256
  , extraPatches ? []
  , withSystemd ? config.php.systemd or stdenv.isLinux
  , imapSupport ? config.php.imap or (!stdenv.isDarwin)
  , ldapSupport ? config.php.ldap or true
  , mhashSupport ? config.php.mhash or false
  , mysqlndSupport ? config.php.mysqlnd or true
  , mysqliSupport ? config.php.mysqli or true
  , pdo_mysqlSupport ? config.php.pdo_mysql or true
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
  , mcryptSupport ? (config.php.mcrypt or true) && (versionOlder version "7.2")
  , bz2Support ? config.php.bz2 or false
  , zipSupport ? config.php.zip or true
  , ftpSupport ? config.php.ftp or true
  , fpmSupport ? config.php.fpm or true
  , gmpSupport ? config.php.gmp or true
  , ztsSupport ? (config.php.zts or false) || (apxs2Support)
  , calendarSupport ? config.php.calendar or true
  , sodiumSupport ? (config.php.sodium or true) && (versionAtLeast version "7.2")
  , tidySupport ? (config.php.tidy or false)
  , argon2Support ? (config.php.argon2 or true) && (versionAtLeast version "7.2")
  , libzipSupport ? (config.php.libzip or true) && (versionAtLeast version "7.2")
  , phpdbgSupport ? config.php.phpdbg or true
  , cgiSupport ? config.php.cgi or true
  , cliSupport ? config.php.cli or true
  , pharSupport ? config.php.phar or true
  , xmlrpcSupport ? (config.php.xmlrpc or false) && (libxml2Support)
  , cgotoSupport ? config.php.cgoto or false
  , valgrindSupport ? (config.php.valgrind or true) && (versionAtLeast version "7.2")
  }:

    let
      mysqlBuildInputs = optional (!mysqlndSupport) mysql.connector-c;
      libmcrypt' = libmcrypt.override { disablePosixThreads = true; };
    in stdenv.mkDerivation {

      inherit version;

      name = "php-${version}";

      enableParallelBuilding = true;

      nativeBuildInputs = [ autoconf bison libtool pkgconfig re2c ];
      buildInputs = [ ]
        ++ optional (versionOlder version "7.3") pcre
        ++ optional (versionAtLeast version "7.3") pcre2
        ++ optional withSystemd systemd
        ++ optionals imapSupport [ uwimap openssl pam ]
        ++ optionals curlSupport [ curl openssl ]
        ++ optionals ldapSupport [ openldap openssl ]
        ++ optionals gdSupport [ libpng libjpeg freetype ]
        ++ optionals opensslSupport [ openssl openssl.dev ]
        ++ optional apxs2Support apacheHttpd
        ++ optional (ldapSupport && stdenv.isLinux) cyrus_sasl
        ++ optional mhashSupport libmhash
        ++ optional zlibSupport zlib
        ++ optional libxml2Support libxml2
        ++ optional readlineSupport readline
        ++ optional sqliteSupport sqlite
        ++ optional postgresqlSupport postgresql
        ++ optional pdo_odbcSupport unixODBC
        ++ optional pdo_pgsqlSupport postgresql
        ++ optional pdo_mysqlSupport mysqlBuildInputs
        ++ optional mysqliSupport mysqlBuildInputs
        ++ optional gmpSupport gmp
        ++ optional gettextSupport gettext
        ++ optional intlSupport icu
        ++ optional xslSupport libxslt
        ++ optional mcryptSupport libmcrypt'
        ++ optional bz2Support bzip2
        ++ optional sodiumSupport libsodium
        ++ optional tidySupport html-tidy
        ++ optional argon2Support libargon2
        ++ optional libzipSupport libzip
        ++ optional valgrindSupport valgrind;

      CXXFLAGS = optional stdenv.cc.isClang "-std=c++11";

      configureFlags = [
        "--with-config-file-scan-dir=/etc/php.d"
      ]
      ++ optional (versionOlder version "7.3") "--with-pcre-regex=${pcre.dev} PCRE_LIBDIR=${pcre}"
      ++ optional (versionAtLeast version "7.3") "--with-pcre-regex=${pcre2.dev} PCRE_LIBDIR=${pcre2}"
      ++ optional stdenv.isDarwin "--with-iconv=${libiconv}"
      ++ optional withSystemd "--with-fpm-systemd"
      ++ optionals imapSupport [
        "--with-imap=${uwimap}"
        "--with-imap-ssl"
      ]
      ++ optionals ldapSupport [
        "--with-ldap=/invalid/path"
        "LDAP_DIR=${openldap.dev}"
        "LDAP_INCDIR=${openldap.dev}/include"
        "LDAP_LIBDIR=${openldap.out}/lib"
      ]
      ++ optional (ldapSupport && stdenv.isLinux)   "--with-ldap-sasl=${cyrus_sasl.dev}"
      ++ optional apxs2Support "--with-apxs2=${apacheHttpd.dev}/bin/apxs"
      ++ optional embedSupport "--enable-embed"
      ++ optional mhashSupport "--with-mhash"
      ++ optional curlSupport "--with-curl=${curl.dev}"
      ++ optional zlibSupport "--with-zlib=${zlib.dev}"
      ++ optional libxml2Support "--with-libxml-dir=${libxml2.dev}"
      ++ optional (!libxml2Support) [
        "--disable-dom"
        "--disable-libxml"
        "--disable-simplexml"
        "--disable-xml"
        "--disable-xmlreader"
        "--disable-xmlwriter"
        "--without-pear"
      ]
      ++ optional pcntlSupport "--enable-pcntl"
      ++ optional readlineSupport "--with-readline=${readline.dev}"
      ++ optional sqliteSupport "--with-pdo-sqlite=${sqlite.dev}"
      ++ optional postgresqlSupport "--with-pgsql=${postgresql}"
      ++ optional pdo_odbcSupport "--with-pdo-odbc=unixODBC,${unixODBC}"
      ++ optional pdo_pgsqlSupport "--with-pdo-pgsql=${postgresql}"
      ++ optional pdo_mysqlSupport "--with-pdo-mysql=${if mysqlndSupport then "mysqlnd" else mysql.connector-c}"
      ++ optionals mysqliSupport [
        "--with-mysqli=${if mysqlndSupport then "mysqlnd" else "${mysql.connector-c}/bin/mysql_config"}"
      ]
      ++ optional ( pdo_mysqlSupport || mysqliSupport ) "--with-mysql-sock=/run/mysqld/mysqld.sock"
      ++ optional bcmathSupport "--enable-bcmath"
      # FIXME: Our own gd package doesn't work, see https://bugs.php.net/bug.php?id=60108.
      ++ optionals gdSupport [
        "--with-gd"
        "--with-freetype-dir=${freetype.dev}"
        "--with-png-dir=${libpng.dev}"
        "--with-jpeg-dir=${libjpeg.dev}"
      ]
      ++ optional gmpSupport "--with-gmp=${gmp.dev}"
      ++ optional soapSupport "--enable-soap"
      ++ optional socketsSupport "--enable-sockets"
      ++ optional opensslSupport "--with-openssl"
      ++ optional mbstringSupport "--enable-mbstring"
      ++ optional gettextSupport "--with-gettext=${gettext}"
      ++ optional intlSupport "--enable-intl"
      ++ optional exifSupport "--enable-exif"
      ++ optional xslSupport "--with-xsl=${libxslt.dev}"
      ++ optional mcryptSupport "--with-mcrypt=${libmcrypt'}"
      ++ optional bz2Support "--with-bz2=${bzip2.dev}"
      ++ optional zipSupport "--enable-zip"
      ++ optional ftpSupport "--enable-ftp"
      ++ optional fpmSupport "--enable-fpm"
      ++ optional ztsSupport "--enable-maintainer-zts"
      ++ optional calendarSupport "--enable-calendar"
      ++ optional sodiumSupport "--with-sodium=${libsodium.dev}"
      ++ optional tidySupport "--with-tidy=${html-tidy}"
      ++ optional argon2Support "--with-password-argon2=${libargon2}"
      ++ optional libzipSupport "--with-libzip=${libzip.dev}"
      ++ optional phpdbgSupport "--enable-phpdbg"
      ++ optional (!phpdbgSupport) "--disable-phpdbg"
      ++ optional (!cgiSupport) "--disable-cgi"
      ++ optional (!cliSupport) "--disable-cli"
      ++ optional (!pharSupport) "--disable-phar"
      ++ optional xmlrpcSupport "--with-xmlrpc"
      ++ optional cgotoSupport "--enable-re2c-cgoto"
      ++ optional valgrindSupport "--with-valgrind=${valgrind.dev}";

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

        #[[ -z "$libxml2" ]] || addToSearchPath PATH $libxml2/bin

        export EXTENSION_DIR=$out/lib/php/extensions

        configureFlags+=(--with-config-file-path=$out/etc \
          --includedir=$dev/include)

        ./buildconf --force
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
        homepage = https://www.php.net/;
        license = licenses.php301;
        maintainers = with maintainers; [ globin etu ];
        platforms = platforms.all;
        outputsToInstall = [ "out" "dev" ];
      };

      patches = [ ./fix-paths-php7.patch ] ++ extraPatches;

      postPatch = optional stdenv.isDarwin ''
        substituteInPlace configure --replace "-lstdc++" "-lc++"
      '';

      stripDebugList = "bin sbin lib modules";

      outputs = [ "out" "dev" ];

    };

in {
  php72 = generic {
    version = "7.2.28";
    sha256 = "18sjvl67z5a2x5s2a36g6ls1r3m4hbrsw52hqr2qsgfvg5dkm5bw";

    # https://bugs.php.net/bug.php?id=76826
    extraPatches = optional stdenv.isDarwin ./php72-darwin-isfinite.patch;
  };

  php73 = generic {
    version = "7.3.15";
    sha256 = "0g84hws15s8gh8iq4h6q747dyfazx47vh3da3whz8d80x83ibgld";

    # https://bugs.php.net/bug.php?id=76826
    extraPatches = optional stdenv.isDarwin ./php73-darwin-isfinite.patch;
  };
}
