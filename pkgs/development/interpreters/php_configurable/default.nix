let version = "5.2.6"; in

args:

(args.mkDerivationByConfiguration {

  flagConfig = {

# much left to do here... 

    mandatory = { buildInputs = ["flex" "bison" "pkgconfig"]; };

    # SAPI modules:
    
    apxs2 = {
      cfgOption = "--with-apxs2=\$apacheHttpd/bin/apxs";
      pass = "apacheHttpd";
    };

    # Extensions 

    curl = {
      cfgOption = "--with-curl=${args.curl} --with-curlwrappers";
      pass = "curl";
    };
      
    zlib = {
      cfgOption = "--with-zlib=${args.zlib}";
      pass = "zlib";
    };

    libxml2 = {
      cfgOption = "--with-libxml-dir=\$libxml2";
      pass = { inherit (args) libxml2; }; 
    };
    
    no_libxml2 = {
      cfgOption = "--disable-libxml";
    };

    postgresql = {
      cfgOption = "--with-pgsql=\$postgresql";
      pass = { inherit (args) postgresql; };
    };
    
    mysql = {
      cfgOption = "--with-mysql=\$mysql";
      pass = { inherit (args) mysql; };
    };

    mysqli = {
      cfgOption = "--with-mysqli=\$mysql/bin/mysql_config";
      pass = { inherit (args) mysql; }; 
    };

    mysqli_embedded = {
      cfgOption = "--enable-embedded-mysqli";
      depends = "mysqli";
    };

    pdo_mysql = {
      cfgOption = "--with-pdo-mysql=\$mysql";
      pass = { inherit (args) mysql; }; 
    };
    
    no_pdo_mysql = { };

    bcmath = {
      cfgOption = "--enable-bcmath";
    };

    gd = {
      cfgOption = "--with-gd=${args.gd}";
      buildInputs = ["gd"]; # <-- urgh, these strings are ugly
    };

    sockets = {
      cfgOption = "--enable-sockets";
    };

    openssl = {
      cfgOption = "--with-openssl=${args.openssl}";
      buildInputs = ["openssl"];
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
      buildInputs = [ "automake" "autoconf" ];
      pass = {
        xdebug_src = args.fetchurl {
          name = "xdebug-2.0.2.tar.gz";
          url = "http://xdebug.org/link.php?url=xdebug202";
          sha256 = "1h0bxvf8krr203fmk1k7izrrr81gz537xmd3pqh4vslwdlbhrvic";
        };
      };
    };

  };

  defaults = [ "mysql" "mysqli" "pdo_mysql" "libxml2" "apxs2" "bcmath" ];
  
  optionals = [ "libxml2" "gettext" "postgresql" "zlib" "openssl" ];

  extraAttrs = co: {
    name = "php_configurable-${version}";

    buildInputs = args.lib.getAttr ["phpIncludes"] [] args ++ co.buildInputs;

    configurePhase = ''
      iniFile=$out/etc/$name.ini
      [[ -z "$libxml2" ]] || export PATH=$PATH:$libxml2/bin
      ./configure --with-config-file-scan-dir=/etc --with-config-file-path=$out/etc --prefix=$out ${co.configureFlags}
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
  };
  
}) args
