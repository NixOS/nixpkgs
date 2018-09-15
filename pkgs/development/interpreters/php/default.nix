# pcre functionality is tested in nixos/tests/php-pcre.nix
{ lib, stdenv, fetchurl, flex, bison
, mysql, libxml2, readline, zlib, curl, postgresql, gettext
, openssl, pcre, pkgconfig, sqlite, config, libjpeg, libpng, freetype
, libxslt, libmcrypt, bzip2, icu, openldap, cyrus_sasl, libmhash, freetds
, uwimap, pam, gmp, apacheHttpd, libiconv, systemd, libsodium, html-tidy
}:

with lib;

let
  generic =
  { version
  , sha256
  , imapSupport ? config.php.imap or (!stdenv.isDarwin)
  , ldapSupport ? config.php.ldap or true
  , mhashSupport ? config.php.mhash or true
  , mysqlSupport ? (config.php.mysql or true)
  , mysqlndSupport ? config.php.mysqlnd or true
  , mysqliSupport ? config.php.mysqli or true
  , pdo_mysqlSupport ? config.php.pdo_mysql or true
  , libxml2Support ? config.php.libxml2 or true
  , apxs2Support ? config.php.apxs2 or (!stdenv.isDarwin)
  , embedSupport ? config.php.embed or false
  , bcmathSupport ? config.php.bcmath or true
  , socketsSupport ? config.php.sockets or true
  , curlSupport ? config.php.curl or true
  , curlWrappersSupport ? config.php.curlWrappers or true
  , gettextSupport ? config.php.gettext or true
  , pcntlSupport ? config.php.pcntl or true
  , postgresqlSupport ? config.php.postgresql or true
  , pdo_pgsqlSupport ? config.php.pdo_pgsql or true
  , readlineSupport ? config.php.readline or true
  , sqliteSupport ? config.php.sqlite or true
  , soapSupport ? config.php.soap or true
  , zlibSupport ? config.php.zlib or true
  , opensslSupport ? config.php.openssl or true
  , mbstringSupport ? config.php.mbstring or true
  , gdSupport ? config.php.gd or true
  # Because of an upstream bug: https://bugs.php.net/bug.php?id=76826
  # We need to disable the intl support on darwin. Whenever the upstream bug is
  # fixed we should revert this to just just "config.php.intl or true".
  , intlSupport ? (config.php.intl or true) && (!stdenv.isDarwin)
  , exifSupport ? config.php.exif or true
  , xslSupport ? config.php.xsl or false
  , mcryptSupport ? config.php.mcrypt or true
  , bz2Support ? config.php.bz2 or false
  , zipSupport ? config.php.zip or true
  , ftpSupport ? config.php.ftp or true
  , fpmSupport ? config.php.fpm or true
  , gmpSupport ? config.php.gmp or true
  , mssqlSupport ? config.php.mssql or (!stdenv.isDarwin)
  , ztsSupport ? config.php.zts or false
  , calendarSupport ? config.php.calendar or true
  , sodiumSupport ? (config.php.sodium or true) && (versionAtLeast version "7.2")
  , tidySupport ? (config.php.tidy or false)
  }:

    let
      mysqlBuildInputs = optional (!mysqlndSupport) mysql.connector-c;
      libmcrypt' = libmcrypt.override { disablePosixThreads = true; };
    in stdenv.mkDerivation {

      inherit version;

      name = "php-${version}";

      enableParallelBuilding = true;

      nativeBuildInputs = [ pkgconfig ];
      buildInputs = [ flex bison pcre ]
        ++ optional stdenv.isLinux systemd
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
        ++ optional pdo_pgsqlSupport postgresql
        ++ optional pdo_mysqlSupport mysqlBuildInputs
        ++ optional mysqlSupport mysqlBuildInputs
        ++ optional mysqliSupport mysqlBuildInputs
        ++ optional gmpSupport gmp
        ++ optional gettextSupport gettext
        ++ optional intlSupport icu
        ++ optional xslSupport libxslt
        ++ optional mcryptSupport libmcrypt'
        ++ optional bz2Support bzip2
        ++ optional (mssqlSupport && !stdenv.isDarwin) freetds
        ++ optional sodiumSupport libsodium
        ++ optional tidySupport html-tidy;

      CXXFLAGS = optional stdenv.cc.isClang "-std=c++11";


      configureFlags = [
        "--with-config-file-scan-dir=/etc/php.d"
        "--with-pcre-regex=${pcre.dev} PCRE_LIBDIR=${pcre}"
      ]
      ++ optional stdenv.isDarwin "--with-iconv=${libiconv}"
      ++ optional stdenv.isLinux  "--with-fpm-systemd"
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
      ++ optional curlWrappersSupport "--with-curlwrappers"
      ++ optional zlibSupport "--with-zlib=${zlib.dev}"
      ++ optional libxml2Support "--with-libxml-dir=${libxml2.dev}"
      ++ optional pcntlSupport "--enable-pcntl"
      ++ optional readlineSupport "--with-readline=${readline.dev}"
      ++ optional sqliteSupport "--with-pdo-sqlite=${sqlite.dev}"
      ++ optional postgresqlSupport "--with-pgsql=${postgresql}"
      ++ optional pdo_pgsqlSupport "--with-pdo-pgsql=${postgresql}"
      ++ optional pdo_mysqlSupport "--with-pdo-mysql=${if mysqlndSupport then "mysqlnd" else mysql.connector-c}"
      ++ optional mysqlSupport "--with-mysql${if mysqlndSupport then "=mysqlnd" else ""}"
      ++ optionals mysqliSupport [
        "--with-mysqli=${if mysqlndSupport then "mysqlnd" else "${mysql.connector-c}/bin/mysql_config"}"
      ]
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
      ++ optional (mssqlSupport && !stdenv.isDarwin) "--with-mssql=${freetds}"
      ++ optional ztsSupport "--enable-maintainer-zts"
      ++ optional calendarSupport "--enable-calendar"
      ++ optional sodiumSupport "--with-sodium=${libsodium.dev}"
      ++ optional tidySupport "--with-tidy=${html-tidy}";


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
      '';

      postInstall = ''
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
        url = "http://www.php.net/distributions/php-${version}.tar.bz2";
        inherit sha256;
      };

      meta = with stdenv.lib; {
        description = "An HTML-embedded scripting language";
        homepage = http://www.php.net/;
        license = licenses.php301;
        maintainers = with maintainers; [ globin etu ];
        platforms = platforms.all;
        outputsToInstall = [ "out" "dev" ];
      };

      patches = [ ./fix-paths-php7.patch ];

      postPatch = optional stdenv.isDarwin ''
        substituteInPlace configure --replace "-lstdc++" "-lc++"
      '';

      stripDebugList = "bin sbin lib modules";

      outputs = [ "out" "dev" ];

    };

in {
  php71 = generic {
    version = "7.1.22";
    sha256 = "0qz74qdlk19cw478f42ckyw5r074y0fg73r2bzlhm0dar0cizsf8";
  };

  php72 = generic {
    version = "7.2.10";
    sha256 = "17fsvdi6ihjghjsz9kk2li2rwrknm2ccb6ys0xmn789116d15dh1";
  };
}
