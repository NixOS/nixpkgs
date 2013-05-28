{ stdenv, fetchurl, composableDerivation, autoconf, automake, flex, bison
, apacheHttpd, mysql, libxml2, readline, zlib, curl, gd, postgresql, gettext
, openssl, pkgconfig, sqlite, config, libiconv, libjpeg, libpng, freetype
, libxslt, libmcrypt, bzip2, icu }:

let
  libmcryptOverride = libmcrypt.override { disablePosixThreads = true; };
in

composableDerivation.composableDerivation {} ( fixed : let inherit (fixed.fixed) version; in {

  version = "5.3.25";

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
        configureFlags = ["--with-gd=${gd} --with-freetype-dir=${freetype}"];
        buildInputs = [gd libpng libjpeg freetype];
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
    mysqlSupport = config.php.mysql or true;
    mysqliSupport = config.php.mysqli or true;
    pdo_mysqlSupport = config.php.pdo_mysql or true;
    libxml2Support = config.php.libxml2 or true;
    apxs2Support = config.php.apxs2 or true;
    bcmathSupport = config.php.bcmath or true;
    socketsSupport = config.php.sockets or true;
    curlSupport = config.php.curl or true;
    gettextSupport = config.php.gettext or true;
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
  };

  configurePhase = ''
    iniFile=$out/etc/php-recommended.ini
    [[ -z "$libxml2" ]] || export PATH=$PATH:$libxml2/bin
    ./configure --with-config-file-scan-dir=/etc --with-config-file-path=$out/etc --prefix=$out $configureFlags
    echo configurePhase end
  '';

  installPhase = ''
    unset installPhase; installPhase;
    cp php.ini-production $iniFile
  '';

  src = fetchurl {
    url = "http://nl.php.net/get/php-${version}.tar.bz2/from/this/mirror";
    sha256 = "15dwks0823m0vc3qv58yxfvchwx9ydg5gjvjy8kpc5w3syras76m";
    name = "php-${version}.tar.bz2";
  };

  meta = {
    description = "The PHP language runtime engine";
    homepage = http://www.php.net/;
    license = "PHP-3";
  };

  patches = [./fix.patch];

})
