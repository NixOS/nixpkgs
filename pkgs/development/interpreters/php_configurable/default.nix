let version = "5.2.6"; in

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
         Building xdebug withing php to be able to add the parameters to the ini file.. Ther should be a better way
        meta = {
                description = "debugging support for PHP";
                homepage = http://xdebug.org;
                license = "based on the PHP license - as is";
                };
      */
      xdebug = {
        buildInputs = [ automake autoconf ];
        xdebug_src = args.fetchurl {
          name = "xdebug-2.0.2.tar.gz";
          url = "http://xdebug.org/link.php?url=xdebug202";
          sha256 = "1h0bxvf8krr203fmk1k7izrrr81gz537xmd3pqh4vslwdlbhrvic";
        };
      };
    };

  cfg = {
    mysqlSupport = true;
    mysqliSupport = true;
    pdo_mysqlSupport = true;
    libxml2Support = true;
    apxs2Support = true;
    bcmathSupport = true;
    socketsSupport = true;
    curlSupport = true;
    gettextSupport = true;
    postgresqlSupport = true;
    zlibSupport = true;
    opnesslSupport = true;
    xdebugSupport = true;
    mbstringSupport = true;
    gdSupport = true;
  };

  configurePhase = ''
    iniFile=$out/etc/$name.ini
    [[ -z "$libxml2" ]] || export PATH=$PATH:$libxml2/bin
    ./configure --with-config-file-scan-dir=/etc --with-config-file-path=$out/etc --prefix=$out  $configureFlags
    echo configurePhase end
  '';

  installPhase = ''
    unset installPhase; installPhase;
    cp php.ini-recommended $iniFile

    # Now Let's build xdebug if flag has been given
    # TODO I think there are better paths than the given below
    if [ -n $flag_set_xdebug ]; then
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
    md5 = "7380ffecebd95c6edb317ef861229ebd";
    name = "php-${version}.tar.bz2";
  };

  meta = {
    description = "The PHP language runtime engine";
    homepage = http://www.php.net/;
    license = "PHP-3";
  };

  patches = [./fix.patch];

})
