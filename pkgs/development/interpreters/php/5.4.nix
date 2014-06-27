{ stdenv, fetchurl, composableDerivation, autoconf, automake, flex, bison
, apacheHttpd, mysql, libxml2, readline, zlib, curl, gd, postgresql, gettext
, openssl, pkgconfig, sqlite, config, libiconv, libjpeg, libpng, freetype
, libxslt, libmcrypt, bzip2, icu, openldap, cyrus_sasl, libmhash, freetds }:

let
  libmcryptOverride = libmcrypt.override { disablePosixThreads = true; };
in

composableDerivation.composableDerivation {} ( fixed : let inherit (fixed.fixed) version; in {

  version = "5.4.30";

  name = "php-${version}";

  enableParallelBuilding = true;

  buildInputs = ["flex" "bison" "pkgconfig"];

  flags = {

    # much left to do here...

    # SAPI modules:

      apxs2 = {
        configureFlags = ["--with-apxs2=${apacheHttpd}/bin/apxs"];
        buildInputs = [apacheHttpd];
      };

      # Extensions

      ldap = {
        configureFlags = ["--with-ldap=${openldap}"];
        buildInputs = [openldap cyrus_sasl openssl];
      };

      mhash = {
        configureFlags = ["--with-mhash"];
        buildInputs = [libmhash];
      };

      curl = {
        configureFlags = ["--with-curl=${curl}" "--with-curlwrappers"];
        buildInputs = [curl openssl];
      };

      zlib = {
        configureFlags = ["--with-zlib=${zlib}"];
        buildInputs = [zlib];
      };

      libxml2 = {
        configureFlags = [
          "--with-libxml-dir=${libxml2}"
          #"--with-iconv-dir=${libiconv}"
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

      mysql = {
        configureFlags = ["--with-mysql=${mysql}"];
        buildInputs = [ mysql ];
      };

      mysqli = {
        configureFlags = ["--with-mysqli=${mysql}/bin/mysql_config"];
        buildInputs = [ mysql];
      };

      mysqli_embedded = {
        configureFlags = ["--enable-embedded-mysqli"];
        depends = "mysqli";
        assertion = fixed.mysqliSupport;
      };

      pdo_mysql = {
        configureFlags = ["--with-pdo-mysql=${mysql}"];
        buildInputs = [ mysql ];
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

      soap = {
        configureFlags = ["--enable-soap"];
      };

      sockets = {
        configureFlags = ["--enable-sockets"];
      };

      openssl = {
        configureFlags = ["--with-openssl=${openssl}"];
        buildInputs = ["openssl"];
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

      mcrypt = {
        configureFlags = ["--with-mcrypt=${libmcrypt}"];
        buildInputs = [libmcryptOverride];
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

      /*
         php is build within this derivation in order to add the xdebug lines to the php.ini.
         So both Apache and command line php both use xdebug without having to configure anything.
         Xdebug could be put in its own derivation.
      * /
        meta = {
                description = "debugging support for PHP";
                homepage = http://xdebug.org;
                license = "based on the PHP license - as is";
                };
      */
    };

  cfg = {
    ldapSupport = config.php.ldap or true;
    mhashSupport = config.php.mhash or true;
    mysqlSupport = config.php.mysql or true;
    mysqliSupport = config.php.mysqli or true;
    pdo_mysqlSupport = config.php.pdo_mysql or true;
    libxml2Support = config.php.libxml2 or true;
    apxs2Support = config.php.apxs2 or true;
    bcmathSupport = config.php.bcmath or true;
    socketsSupport = config.php.sockets or true;
    curlSupport = config.php.curl or true;
    gettextSupport = config.php.gettext or true;
    pcntlSupport = config.php.pcntl or true;
    postgresqlSupport = config.php.postgresql or true;
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
    mcryptSupport = config.php.mcrypt or false;
    bz2Support = config.php.bz2 or false;
    zipSupport = config.php.zip or true;
    ftpSupport = config.php.ftp or true;
    fpmSupport = config.php.fpm or true;
    mssqlSupport = config.php.mssql or (!stdenv.isDarwin);
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
    sha256 = "1rkc977b4k0y6qg5nf8729g5zpica31h1isyds6khmrdwi23df1j";
  };

  meta = {
    description = "The PHP language runtime engine";
    homepage = http://www.php.net/;
    license = "PHP-3";
  };

  patches = [ ./fix-5.4.patch ];

})
