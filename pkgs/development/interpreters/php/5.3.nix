{ stdenv, fetchurl, composableDerivation, autoconf, automake, flex, bison
, apacheHttpd, mysql, libxml2, readline, zlib, curl, gd, postgresql, gettext
, openssl, pkgconfig, sqlite, config, libjpeg, libpng, freetype, libxslt
, libmcrypt, bzip2, icu, libssh2, makeWrapper, libiconvOrEmpty, libiconv, uwimap
, pam }:

let
  libmcryptOverride = libmcrypt.override { disablePosixThreads = true; };
in

composableDerivation.composableDerivation {} ( fixed : let inherit (fixed.fixed) version; in {

  version = "5.3.28";

  name = "php-${version}";

  enableParallelBuilding = true;

  buildInputs
    = [ flex bison pkgconfig ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libssh2 makeWrapper ];

  # need to include the C++ standard library when compiling on darwin
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lstdc++";

  # need to specify where the dylib for icu is stored
  DYLD_LIBRARY_PATH = stdenv.lib.optionalString stdenv.isDarwin "${icu}/lib";

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

      pcntl = {
        configureFlags = [ "--enable-pcntl" ];
      };

      zlib = {
        configureFlags = ["--with-zlib=${zlib}"];
        buildInputs = [zlib];
      };

      libxml2 = {
        configureFlags
          = [ "--with-libxml-dir=${libxml2}" ]
            ++ stdenv.lib.optional (libiconvOrEmpty != [])
              [ "--with-iconv=${libiconv}" ];
        buildInputs = [ libxml2 ] ++ libiconvOrEmpty;
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
        configureFlags = [
          "--with-gd=${gd}"
          "--with-freetype-dir=${freetype}"
          "--with-png-dir=${libpng}"
          "--with-jpeg-dir=${libjpeg}"
        ];
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

      imap = {
        configureFlags = [ "--with-imap=${uwimap}" "--with-imap-ssl" ]
          # uwimap builds with kerberos on darwin
          ++ stdenv.lib.optional (stdenv.isDarwin) "--with-kerberos";
        buildInputs = [ uwimap openssl ]
          ++ stdenv.lib.optional (!stdenv.isDarwin) pam;
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
    };

  cfg = {
    apxs2Support = config.php.apxs2 or true;
    bcmathSupport = config.php.bcmath or true;
    bz2Support = config.php.bz2 or false;
    curlSupport = config.php.curl or true;
    exifSupport = config.php.exif or true;
    ftpSupport = config.php.ftp or true;
    fpmSupport = config.php.fpm or false;
    gdSupport = config.php.gd or true;
    gettextSupport = config.php.gettext or true;
    imapSupport = config.php.imap or false;
    intlSupport = config.php.intl or true;
    libxml2Support = config.php.libxml2 or true;
    mbstringSupport = config.php.mbstring or true;
    mcryptSupport = config.php.mcrypt or false;
    mysqlSupport = config.php.mysql or true;
    mysqliSupport = config.php.mysqli or true;
    opensslSupport = config.php.openssl or true;
    pcntlSupport = config.php.pcntl or true;
    pdo_mysqlSupport = config.php.pdo_mysql or true;
    postgresqlSupport = config.php.postgresql or true;
    readlineSupport = config.php.readline or true;
    soapSupport = config.php.soap or true;
    socketsSupport = config.php.sockets or true;
    sqliteSupport = config.php.sqlite or true;
    xslSupport = config.php.xsl or false;
    zipSupport = config.php.zip or true;
    zlibSupport = config.php.zlib or true;
  };

  configurePhase = ''
    iniFile=$out/etc/php-recommended.ini
    [[ -z "$libxml2" ]] || export PATH=$PATH:$libxml2/bin
    ./configure --with-config-file-scan-dir=/etc --with-config-file-path=$out/etc --prefix=$out $configureFlags
    echo configurePhase end
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # don't build php.dSYM as the php binary
    sed -i 's/EXEEXT = \.dSYM/EXEEXT =/' Makefile
  '';

  installPhase = ''
    unset installPhase; installPhase;
    cp php.ini-production $iniFile
  '' + ( stdenv.lib.optionalString stdenv.isDarwin ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "$DYLD_LIBRARY_PATH"
    done
  '' );

  src = fetchurl {
    url = "http://www.php.net/distributions/php-${version}.tar.bz2";
    sha256 = "04w53nn6qacpkd1x381mzd41kqh6k8kjnbyg44yvnkqwcl69db0c";
    name = "php-${version}.tar.bz2";
  };

  meta = {
    description = "The PHP language runtime engine";
    homepage    = http://www.php.net/;
    license     = "PHP-3";
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    platforms   = stdenv.lib.platforms.unix;
  };

  patches = [./fix.patch];

})
