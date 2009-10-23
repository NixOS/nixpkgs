let version = "5.2.9"; in

args: with args;

let inherit (args.composableDerivation) composableDerivation edf wwf; in

composableDerivation {} ( fixed : {

  name = "php_configurable-${version}";

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
        configureFlags = ["--with-curl=${args.curl}" "--with-curlwrappers"];
        buildInputs = [curl openssl];
      };
      
      zlib = {
        configureFlags = ["--with-zlib=${args.zlib}"];
        buildInputs = [zlib];
      };

      libxml2 = {
        configureFlags = ["--with-libxml-dir=${libxml2}"];
        buildInputs = [ libxml2 ];
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
        configureFlags = ["--with-gd=${args.gd}"];
        buildInputs = [gd];
      };

      soap = {
        configureFlags = ["--enable-soap"];
      };

      sockets = {
        configureFlags = ["--enable-sockets"];
      };

      openssl = {
        configureFlags = ["--with-openssl=${args.openssl}"];
        buildInputs = ["openssl"];
      };

      mbstring = {
        configureFlags = ["--enable-mbstring"];
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
      xdebug = {
        buildInputs = [ automake autoconf ];
        xdebug_src = args.fetchurl {
          url = "http://xdebug.org/files/xdebug-2.0.5.tgz";
          sha256 = "1cmq7c36gj8n41mfq1wba5rij8j77yqhydpcsbcysk1zchg68f26";
        };
      };
    };

  cfg = {
    mysqlSupport = getConfig ["php" "mysql"] true;
    mysqliSupport = getConfig ["php" "mysqli"] true;
    pdo_mysqlSupport = getConfig ["php" "pdo_mysql"] true;
    libxml2Support = getConfig ["php" "libxml2"] true;
    apxs2Support = getConfig ["php" "apxs2"] true;
    bcmathSupport = getConfig ["php" "bcmath"] true;
    socketsSupport = getConfig ["php" "sockets"] true;
    curlSupport = getConfig ["php" "curl"] true;
    gettextSupport = getConfig ["php" "gettext"] true;
    postgresqlSupport = getConfig ["php" "postgresql"] true;
    sqliteSupport = getConfig ["php" "sqlite"] true;
    soapSupport = getConfig ["php" "soap"] true;
    zlibSupport = getConfig ["php" "zlib"] true;
    opensslSupport = getConfig ["php" "openssl"] true;
    xdebugSupport = getConfig ["php" "xdebug"] false;
    mbstringSupport = getConfig ["php" "mbstring"] true;
    gdSupport = getConfig ["php" "gd"] true;
  };

  # only -O1
  configurePhase = ''
    iniFile=$out/etc/$name.ini
    [[ -z "$libxml2" ]] || export PATH=$PATH:$libxml2/bin
    ./configure --with-config-file-scan-dir=/etc --with-config-file-path=$out/etc --prefix=$out  $configureFlags
    echo configurePhase end
    sed -e 's/-O2/-O1/g' -i Makefile # http://bugs.php.net/bug.php?id=47730&edit=3
  '';

  installPhase = ''
    unset installPhase; installPhase;
    cp php.ini-recommended $iniFile

    # Now Let's build xdebug if flag has been given
    # TODO I think there are better paths than the given below
    if [ -n "$xdebug_src" ]; then
      PATH=$PATH:$out/bin
      tar xfz $xdebug_src;
      cd xdebug*
      phpize
      ./configure --prefix=$out
      make
      ensureDir $out/lib; cp modules/xdebug.so $out/lib
      cat >> $out/etc/php.ini << EOF
        zend_extension="$out/lib/xdebug.so"
        zend_extension_ts="$out/lib/xdebug.so"
        zend_extension_debug="$out/lib/xdebug.so"
        xdebug.remote_enable=true
        xdebug.remote_host=127.0.0.1
        xdebug.remote_port=9000
        xdebug.remote_handler=dbgp
        xdebug.profiler_enable=0
        xdebug.profiler_output_dir="/tmp/xdebug"
        xdebug.remote_mode=req
        max_execution_time = 300
        date.timezone = UTC
  EOF
    fi
  '';

  src = args.fetchurl {
    url = "http://nl.php.net/get/php-${version}.tar.bz2/from/this/mirror";
    md5 = "280d6cda7f72a4fc6de42fda21ac2db7";
    name = "php-${version}.tar.bz2";
  };

  meta = {
    description = "The PHP language runtime engine";
    homepage = http://www.php.net/;
    license = "PHP-3";
  };

  patches = [./fix.patch];

})
