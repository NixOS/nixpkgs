{ lib, stdenv, fetchurl, composableDerivation, autoconf, automake, flex, bison
, mysql, libxml2, readline, zlib, curl, postgresql, gettext
, openssl, pkgconfig, sqlite, config, libjpeg, libpng, freetype
, libxslt, libmcrypt, bzip2, icu, openldap, cyrus_sasl, libmhash, freetds
, uwimap, pam, gmp, apacheHttpd }:

let

  generic =
    { version, sha256 }:

    let php7 = lib.versionAtLeast version "7.0"; in

    composableDerivation.composableDerivation {} (fixed: {

      inherit version;

      name = "php-${version}";

      enableParallelBuilding = true;

      buildInputs = [ flex bison pkgconfig ];

      configureFlags = ["EXTENSION_DIR=$(out)/lib/php/extensions"];

      flags = {

        # much left to do here...

        # SAPI modules:

        apxs2 = {
          configureFlags = ["--with-apxs2=${apacheHttpd}/bin/apxs"];
          buildInputs = [apacheHttpd];
        };

        # Extensions
        imap = {
          configureFlags = [
            "--with-imap=${uwimap}"
            "--with-imap-ssl"
            ];
          buildInputs = [ uwimap openssl pam ];
        };

        ldap = {
          configureFlags = ["--with-ldap=${openldap}"];
          buildInputs = [openldap cyrus_sasl openssl];
        };

        mhash = {
          configureFlags = ["--with-mhash"];
          buildInputs = [libmhash];
        };

        curl = {
          configureFlags = ["--with-curl=${curl}"];
          buildInputs = [curl openssl];
        };

        curlWrappers = {
          configureFlags = ["--with-curlwrappers"];
        };

        zlib = {
          configureFlags = ["--with-zlib=${zlib}"];
          buildInputs = [zlib];
        };

        libxml2 = {
          configureFlags = [
            "--with-libxml-dir=${libxml2}"
            ];
          buildInputs = [ libxml2 ];
        };

        pcntl = {
          configureFlags = [ "--enable-pcntl" ];
        };

        readline = {
          configureFlags = ["--with-readline=${readline}"];
          buildInputs = [ readline ];
        };

        sqlite = {
          configureFlags = ["--with-pdo-sqlite=${sqlite}"];
          buildInputs = [ sqlite ];
        };

        postgresql = {
          configureFlags = ["--with-pgsql=${postgresql}"];
          buildInputs = [ postgresql ];
        };

        pdo_pgsql = {
          configureFlags = ["--with-pdo-pgsql=${postgresql}"];
          buildInputs = [ postgresql ];
        };

        mysql = {
          configureFlags =
            throw "MySQL support in PHP is broken! (See https://github.com/NixOS/nixpkgs/issues/14351.)";
            #["--with-mysql=${mysql.lib}"];
          buildInputs = [ mysql.lib ];
        };

        mysqli = {
          configureFlags = ["--with-mysqli=${mysql.lib}/bin/mysql_config"];
          buildInputs = [ mysql.lib ];
        };

        mysqli_embedded = {
          configureFlags = ["--enable-embedded-mysqli"];
          depends = "mysqli";
          assertion = fixed.mysqliSupport;
        };

        pdo_mysql = {
          configureFlags = ["--with-pdo-mysql=${mysql.lib}"];
          buildInputs = [ mysql.lib ];
        };

        bcmath = {
          configureFlags = ["--enable-bcmath"];
        };

        gd = {
          # FIXME: Our own gd package doesn't work, see https://bugs.php.net/bug.php?id=60108.
          configureFlags = [
            "--with-gd"
            "--with-freetype-dir=${freetype}"
            "--with-png-dir=${libpng}"
            "--with-jpeg-dir=${libjpeg}"
          ];
          buildInputs = [ libpng libjpeg freetype ];
        };

        gmp = {
          configureFlags = ["--with-gmp=${gmp}"];
          buildInputs = [ gmp ];
        };

        soap = {
          configureFlags = ["--enable-soap"];
        };

        sockets = {
          configureFlags = ["--enable-sockets"];
        };

        openssl = {
          configureFlags = ["--with-openssl=${openssl}"];
          buildInputs = [openssl];
        };

        mbstring = {
          configureFlags = ["--enable-mbstring"];
        };

        gettext = {
          configureFlags = ["--with-gettext=${gettext}"];
          buildInputs = [gettext];
        };

        intl = {
          configureFlags = ["--enable-intl"];
          buildInputs = [icu];
        };

        exif = {
          configureFlags = ["--enable-exif"];
        };

        xsl = {
          configureFlags = ["--with-xsl=${libxslt}"];
          buildInputs = [libxslt];
        };

        mcrypt = let libmcrypt' = libmcrypt.override { disablePosixThreads = true; }; in {
          configureFlags = ["--with-mcrypt=${libmcrypt'}"];
          buildInputs = [libmcrypt'];
        };

        bz2 = {
          configureFlags = ["--with-bz2=${bzip2}"];
          buildInputs = [bzip2];
        };

        zip = {
          configureFlags = ["--enable-zip"];
        };

        ftp = {
          configureFlags = ["--enable-ftp"];
        };

        fpm = {
          configureFlags = ["--enable-fpm"];
        };

        mssql = stdenv.lib.optionalAttrs (!stdenv.isDarwin) {
          configureFlags = ["--with-mssql=${freetds}"];
          buildInputs = [freetds];
        };

        zts = {
          configureFlags = ["--enable-maintainer-zts"];
        };

        calendar = {
          configureFlags = ["--enable-calendar"];
        };
      };

      cfg = {
        imapSupport = config.php.imap or true;
        ldapSupport = config.php.ldap or true;
        mhashSupport = config.php.mhash or true;
        mysqlSupport = (!php7) && (config.php.mysql or false);
        mysqliSupport = config.php.mysqli or false;
        pdo_mysqlSupport = config.php.pdo_mysql or false;
        libxml2Support = config.php.libxml2 or true;
        apxs2Support = config.php.apxs2 or true;
        bcmathSupport = config.php.bcmath or true;
        socketsSupport = config.php.sockets or true;
        curlSupport = config.php.curl or true;
        curlWrappersSupport = (!php7) && (config.php.curlWrappers or true);
        gettextSupport = config.php.gettext or true;
        pcntlSupport = config.php.pcntl or true;
        postgresqlSupport = config.php.postgresql or true;
        pdo_pgsqlSupport = config.php.pdo_pgsql or true;
        readlineSupport = config.php.readline or true;
        sqliteSupport = config.php.sqlite or true;
        soapSupport = config.php.soap or true;
        zlibSupport = config.php.zlib or true;
        opensslSupport = config.php.openssl or true;
        mbstringSupport = config.php.mbstring or true;
        gdSupport = config.php.gd or true;
        intlSupport = config.php.intl or true;
        exifSupport = config.php.exif or true;
        xslSupport = config.php.xsl or false;
        mcryptSupport = config.php.mcrypt or true;
        bz2Support = config.php.bz2 or false;
        zipSupport = config.php.zip or true;
        ftpSupport = config.php.ftp or true;
        fpmSupport = config.php.fpm or true;
        gmpSupport = config.php.gmp or true;
        mssqlSupport = (!php7) && (config.php.mssql or (!stdenv.isDarwin));
        ztsSupport = config.php.zts or false;
        calendarSupport = config.php.calendar or true;
      };

      configurePhase = ''
        # Don't record the configure flags since this causes unnecessary
        # runtime dependencies.
        for i in main/build-defs.h.in scripts/php-config.in; do
          substituteInPlace $i \
            --replace '@CONFIGURE_COMMAND@' '(omitted)' \
            --replace '@CONFIGURE_OPTIONS@' "" \
            --replace '@PHP_LDFLAGS@' ""
        done

        iniFile=$out/etc/php-recommended.ini
        [[ -z "$libxml2" ]] || export PATH=$PATH:$libxml2/bin
        ./configure --with-config-file-scan-dir=/etc --with-config-file-path=$out/etc --prefix=$out $configureFlags
      '';

      installPhase = ''
        unset installPhase; installPhase;
        cp php.ini-production $iniFile
      '';

      src = fetchurl {
        url = "http://www.php.net/distributions/php-${version}.tar.bz2";
        inherit sha256;
      };

      meta = with stdenv.lib; {
        description = "An HTML-embedded scripting language";
        homepage = http://www.php.net/;
        license = stdenv.lib.licenses.php301;
        maintainers = with maintainers; [ globin ];
      };

      patches = if !php7 then [ ./fix-paths.patch ] else [ ./fix-paths-php7.patch ];

    });

in {

  php55 = generic {
    version = "5.5.34";
    sha256 = "0745wn0qg9rqibwr948bzc719s7pywizvl1ahkg1j9m92r28i25g";
  };

  php56 = generic {
    version = "5.6.20";
    sha256 = "07xz48dz1ijwq45vh90jfzdd56k0s5ppi3j5rwc9p9y7mrybziss";
  };

  php70 = generic {
    version = "7.0.5";
    sha256 = "1s8xnnxwq5big2rnbp3w7zw7wh5d5ra9p2q9bxwylds5wrzsy29c";
  };

}
