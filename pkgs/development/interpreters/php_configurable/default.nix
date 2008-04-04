/*  TODO check security issues such as :
+--------------------------------------------------------------------+
|                        *** WARNING ***                             |
|                                                                    |
| You will be compiling the CGI version of PHP without any           |
| redirection checking.  By putting this cgi binary somewhere in     |
| your web space, users may be able to circumvent existing .htaccess |
| security by loading files directly through the parser.  See        |
| http://www.php.net/manual/security.php for more details.           |
*/

let version = "5.2.5"; in

args:
( args.mkDerivationByConfiguration {
    flagConfig = {

    /*

    // The order tries to represent the order given by configure --help 
       The nix option representation of implemented options is given below
       only some opitions right now.. They'll grow when I need them

    Configuration:
      --cache-file=FILE       cache test results in FILE
      --help                  print this message
      --no-create             do not create output files
      --quiet, --silent       do not print `checking...' messages
      --version               print the version of autoconf that created configure

    Directory and file names:
      --prefix=PREFIX         install architecture-independent files in PREFIX
                              [/usr/local]
      --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
                              [same as prefix]
      --bindir=DIR            user executables in DIR [EPREFIX/bin]
      --sbindir=DIR           system admin executables in DIR [EPREFIX/sbin]
      --libexecdir=DIR        program executables in DIR [EPREFIX/libexec]
      --datadir=DIR           read-only architecture-independent data in DIR
                              [PREFIX/share]
      --sysconfdir=DIR        read-only single-machine data in DIR [PREFIX/etc]
      --sharedstatedir=DIR    modifiable architecture-independent data in DIR
                              [PREFIX/com]
      --localstatedir=DIR     modifiable single-machine data in DIR [PREFIX/var]
      --libdir=DIR            object code libraries in DIR [EPREFIX/lib]
      --includedir=DIR        C header files in DIR [PREFIX/include]
      --oldincludedir=DIR     C header files for non-gcc in DIR [/usr/include]
      --infodir=DIR           info documentation in DIR [PREFIX/info]
      --mandir=DIR            man documentation in DIR [PREFIX/man]
      --srcdir=DIR            find the sources in DIR [configure dir or ..]
      --program-prefix=PREFIX prepend PREFIX to installed program names
      --program-suffix=SUFFIX append SUFFIX to installed program names
      --program-transform-name=PROGRAM
                              run sed PROGRAM on installed program names
    Host type:
      --build=BUILD           configure for building on BUILD [BUILD=HOST]
      --host=HOST             configure for HOST [guessed]
      --target=TARGET         configure for TARGET [TARGET=HOST]
    Features and packages:
      --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
      --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
      --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
      --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
      --x-includes=DIR        X include files are in DIR
      --x-libraries=DIR       X library files are in DIR
    --enable and --with options recognized:
      --with-libdir=NAME      Look for libraries in .../NAME rather than .../lib
      --disable-rpath         Disable passing additional runtime library
                              search paths



    SAPI modules:

      --with-aolserver=DIR    Specify path to the installed AOLserver
      --with-apxs[=FILE]      Build shared Apache 1.x module. FILE is the optional
                              pathname to the Apache apxs tool [apxs]
      --with-apache[=DIR]     Build Apache 1.x module. DIR is the top-level Apache
                              build directory [/usr/local/apache]
      --enable-mod-charset      APACHE: Enable transfer tables for mod_charset (Rus Apache)
      --with-apxs2filter[=FILE]   
                              EXPERIMENTAL: Build shared Apache 2.0 Filter module. FILE is the optional
                              pathname to the Apache apxs tool [apxs]
      --with-apxs2[=FILE]     Build shared Apache 2.0 Handler module. FILE is the optional
                              pathname to the Apache apxs tool [apxs]
      --with-apache-hooks[=FILE]      
                              EXPERIMENTAL: Build shared Apache 1.x module. FILE is the optional
                              pathname to the Apache apxs tool [apxs]
      --with-apache-hooks-static[=DIR]
                              EXPERIMENTAL: Build Apache 1.x module. DIR is the top-level Apache
                              build directory [/usr/local/apache]
      --enable-mod-charset      APACHE (hooks): Enable transfer tables for mod_charset (Rus Apache)
      --with-caudium[=DIR]    Build PHP as a Pike module for use with Caudium.
                              DIR is the Caudium server dir [/usr/local/caudium/server]
      --disable-cli           Disable building CLI version of PHP
                              (this forces --without-pear)
      --with-continuity=DIR   Build PHP as Continuity Server module. 
                              DIR is path to the installed Continuity Server root
      --enable-embed[=TYPE]   EXPERIMENTAL: Enable building of embedded SAPI library
                              TYPE is either 'shared' or 'static'. [TYPE=shared]
      --with-isapi[=DIR]      Build PHP as an ISAPI module for use with Zeus
      --with-milter[=DIR]     Build PHP as Milter application
      --with-nsapi=DIR        Build PHP as NSAPI module for Netscape/iPlanet/Sun Webserver
      --with-phttpd=DIR       Build PHP as phttpd module
      --with-pi3web[=DIR]     Build PHP as Pi3Web module
      --with-roxen=DIR        Build PHP as a Pike module. DIR is the base Roxen
                              directory, normally /usr/local/roxen/server
      --enable-roxen-zts        ROXEN: Build the Roxen module using Zend Thread Safety
      --with-thttpd=SRCDIR    Build PHP as thttpd module
      --with-tux=MODULEDIR    Build PHP as a TUX module (Linux only)
      --with-webjames=SRCDIR  Build PHP as a WebJames module (RISC OS only)
      --disable-cgi           Disable building CGI version of PHP
      --enable-fastcgi          CGI: Enable FastCGI support in the CGI binary
      --enable-force-cgi-redirect
                                CGI: Enable security check for internal server
                                redirects. Use this if you run the PHP CGI with Apache
      --enable-discard-path     CGI: When this is enabled the PHP CGI binary can 
                                safely be placed outside of the web tree and people
                                will not be able to circumvent .htaccess security
      --disable-path-info-check CGI: If this is disabled, paths such as
                                /info.php/test?a=b will fail to work


    General settings:

      --enable-gcov           Enable GCOV code coverage (requires LTP) - FOR DEVELOPERS ONLY!!
      --enable-debug          Compile with debugging symbols
      --with-layout=TYPE      Set how installed files will be laid out.  Type can
                              be either PHP or GNU [PHP]
      --with-config-file-path=PATH
                              Set the path in which to look for php.ini [PREFIX/lib]
      --with-config-file-scan-dir=PATH
                              Set the path where to scan for configuration files
      --enable-safe-mode      Enable safe mode by default
      --with-exec-dir[=DIR]   Only allow executables in DIR under safe-mode
                              [/usr/local/php/bin]
      --enable-sigchild       Enable PHP's own SIGCHLD handler
      --enable-magic-quotes   Enable magic quotes by default.
      --enable-libgcc         Enable explicitly linking against libgcc
      --disable-short-tags    Disable the short-form <? start tag by default
      --enable-dmalloc        Enable dmalloc
      --disable-ipv6          Disable IPv6 support
      --enable-fd-setsize     Set size of descriptor sets


    Extensions:

      --with-EXTENSION=[shared[,PATH]]
      
        NOTE: Not all extensions can be build as 'shared'.

        Example: --with-foobar=shared,/usr/local/foobar/

          o Builds the foobar extension as shared extension.
          o foobar package install prefix is /usr/local/foobar/


     --disable-all   Disable all extensions which are enabled by default


      --disable-libxml        Disable LIBXML support
      --with-libxml-dir[=DIR]   LIBXML: libxml2 install prefix
      --with-openssl[=DIR]    Include OpenSSL support (requires OpenSSL >= 0.9.6)
      --with-kerberos[=DIR]     OPENSSL: Include Kerberos support
      --without-pcre-regex    Do not include Perl Compatible Regular Expressions support.
                              DIR is the PCRE install prefix [BUNDLED]
      --with-zlib[=DIR]       Include ZLIB support (requires zlib >= 1.0.9)
      --with-zlib-dir=<DIR>   Define the location of zlib install directory
      --enable-bcmath         Enable bc style precision math functions
      --with-bz2[=DIR]        Include BZip2 support
      --enable-calendar       Enable support for calendar conversion
      --disable-ctype         Disable ctype functions
      --with-curl[=DIR]       Include cURL support
      --with-curlwrappers     Use cURL for url streams
      --enable-dba            Build DBA with bundled modules. To build shared DBA
                              extension use --enable-dba=shared
      --with-qdbm[=DIR]         DBA: QDBM support
      --with-gdbm[=DIR]         DBA: GDBM support
      --with-ndbm[=DIR]         DBA: NDBM support
      --with-db4[=DIR]          DBA: Berkeley DB4 support
      --with-db3[=DIR]          DBA: Berkeley DB3 support
      --with-db2[=DIR]          DBA: Berkeley DB2 support
      --with-db1[=DIR]          DBA: Berkeley DB1 support/emulation
      --with-dbm[=DIR]          DBA: DBM support
      --without-cdb[=DIR]       DBA: CDB support (bundled)
      --disable-inifile         DBA: INI support (bundled)
      --disable-flatfile        DBA: FlatFile support (bundled)
      --enable-dbase          Enable the bundled dbase library
      --disable-dom           Disable DOM support
      --with-libxml-dir[=DIR]   DOM: libxml2 install prefix
      --enable-exif           Enable EXIF (metadata from images) support
      --with-fbsql[=DIR]      Include FrontBase support. DIR is the FrontBase base directory
      --with-fdftk[=DIR]      Include FDF support
      --disable-filter        Disable input filter support
      --with-pcre-dir           FILTER: pcre install prefix
      --enable-ftp            Enable FTP support
      --with-openssl-dir[=DIR]  FTP: openssl install prefix
      --with-gd[=DIR]         Include GD support.  DIR is the GD library base
                              install directory [BUNDLED]
      --with-jpeg-dir[=DIR]     GD: Set the path to libjpeg install prefix
      --with-png-dir[=DIR]      GD: Set the path to libpng install prefix
      --with-zlib-dir[=DIR]     GD: Set the path to libz install prefix
      --with-xpm-dir[=DIR]      GD: Set the path to libXpm install prefix
      --with-ttf[=DIR]          GD: Include FreeType 1.x support
      --with-freetype-dir[=DIR] GD: Set the path to FreeType 2 install prefix
      --with-t1lib[=DIR]        GD: Include T1lib support. T1lib version >= 5.0.0 required
      --enable-gd-native-ttf    GD: Enable TrueType string function
      --enable-gd-jis-conv      GD: Enable JIS-mapped Japanese font support
      */
      gettext =     { cfgOption = "--with-gettext=\$gettext"; pass={ inherit (args) gettext; }; buildInputs="gettext"; };                    #Include GNU gettext support
      #gettext =     { cfgOption = "--with-gettext"; buildInputs="gettext"; };                    #Include GNU gettext support
      /*
      --with-gmp[=DIR]        Include GNU MP support
      --disable-hash          Disable hash support
      --without-iconv[=DIR]   Exclude iconv support
      --with-imap[=DIR]       Include IMAP support. DIR is the c-client install prefix
      --with-kerberos[=DIR]     IMAP: Include Kerberos support. DIR is the Kerberos install prefix
      --with-imap-ssl[=DIR]     IMAP: Include SSL support. DIR is the OpenSSL install prefix
      --with-interbase[=DIR]  Include InterBase support.  DIR is the InterBase base
                              install directory [/usr/interbase]
      --disable-json          Disable JavaScript Object Serialization support
      --with-ldap[=DIR]       Include LDAP support
      --with-ldap-sasl[=DIR]    LDAP: Include Cyrus SASL support
      --enable-mbstring       Enable multibyte string support
      --disable-mbregex         MBSTRING: Disable multibyte regex support
      --disable-mbregex-backtrack
                                MBSTRING: Disable multibyte regex backtrack check
      --with-libmbfl[=DIR]      MBSTRING: Use external libmbfl.  DIR is the libmbfl base
                                install directory [BUNDLED]
      --with-mcrypt[=DIR]     Include mcrypt support
      --with-mhash[=DIR]      Include mhash support



      --with-mime-magic[=FILE]  
                              Include mime_magic support (DEPRECATED!!)
      --with-ming[=DIR]       Include MING support
      --with-msql[=DIR]       Include mSQL support.  DIR is the mSQL base
                              install directory [/usr/local/Hughes]
      --with-mssql[=DIR]      Include MSSQL-DB support.  DIR is the FreeTDS home
                              directory [/usr/local/freetds]
      --with-mysql[=DIR]      Include MySQL support. DIR is the MySQL base directory
      --with-mysql-sock[=DIR]   MySQL: Location of the MySQL unix socket pointer.
                                If unspecified, the default locations are searched
      --with-zlib-dir[=DIR]     MySQL: Set the path to libz install prefix
      --with-mysqli[=FILE]    Include MySQLi support.  FILE is the optional pathname 
                              to mysql_config [mysql_config]
      --enable-embedded-mysqli  MYSQLi: Enable embedded support
      --with-ncurses[=DIR]    Include ncurses support (CLI/CGI only)
      --with-oci8[=DIR]       Include Oracle (OCI8) support. DIR defaults to $ORACLE_HOME.
                              Use --with-oci8=instantclient,/path/to/oic/lib 
                              for an Oracle Instant Client installation
      --with-adabas[=DIR]     Include Adabas D support [/usr/local]
      --with-sapdb[=DIR]      Include SAP DB support [/usr/local]
      --with-solid[=DIR]      Include Solid support [/usr/local/solid]
      --with-ibm-db2[=DIR]    Include IBM DB2 support [/home/db2inst1/sqllib]
      --with-ODBCRouter[=DIR] Include ODBCRouter.com support [/usr]
      --with-empress[=DIR]    Include Empress support [$EMPRESSPATH]
                              (Empress Version >= 8.60 required)
      --with-empress-bcs[=DIR]
                              Include Empress Local Access support [$EMPRESSPATH]
                              (Empress Version >= 8.60 required)
      --with-birdstep[=DIR]   Include Birdstep support [/usr/local/birdstep]
      --with-custom-odbc[=DIR]
                              Include user defined ODBC support. DIR is ODBC install base
                              directory [/usr/local]. Make sure to define CUSTOM_ODBC_LIBS and
                              have some odbc.h in your include dirs. f.e. you should define 
                              following for Sybase SQL Anywhere 5.5.00 on QNX, prior to
                              running this configure script:
                                  CPPFLAGS="-DODBC_QNX -DSQLANY_BUG"
                                  LDFLAGS=-lunix
                                  CUSTOM_ODBC_LIBS="-ldblib -lodbc"
      --with-iodbc[=DIR]      Include iODBC support [/usr/local]
      --with-esoob[=DIR]      Include Easysoft OOB support [/usr/local/easysoft/oob/client]
      --with-unixODBC[=DIR]   Include unixODBC support [/usr/local]
      --with-dbmaker[=DIR]    Include DBMaker support
      --enable-pcntl          Enable experimental pcntl support (CLI/CGI only)
      --disable-pdo           Disable PHP Data Objects support
      --with-pdo-dblib[=DIR]    PDO: DBLIB-DB support.  DIR is the FreeTDS home
                                directory
      --with-pdo-firebird[=DIR] PDO: Firebird support.  DIR is the Firebird base
                                install directory [/opt/firebird]
      --with-pdo-mysql[=DIR]    PDO: MySQL support. DIR is the MySQL base directory
      --with-zlib-dir[=DIR]       PDO_MySQL: Set the path to libz install prefix
      --with-pdo-oci[=DIR]      PDO: Oracle-OCI support. DIR defaults to $ORACLE_HOME.
                                Use --with-pdo-oci=instantclient,prefix,version 
                                for an Oracle Instant Client SDK. 
                                For Linux with 10.2.0.3 RPMs (for example) use:
                                --with-pdo-oci=instantclient,/usr,10.2.0.3
      --with-pdo-odbc=flavour,dir
                                PDO: Support for 'flavour' ODBC driver.
                                include and lib dirs are looked for under 'dir'.
                                
                                'flavour' can be one of:  ibm-db2, unixODBC, generic
                                If ',dir' part is omitted, default for the flavour 
                                you have selected will used. e.g.:
                                
                                  --with-pdo-odbc=unixODBC
                                  
                                will check for unixODBC under /usr/local. You may attempt 
                                to use an otherwise unsupported driver using the "generic" 
                                flavour.  The syntax for generic ODBC support is:
                                
                                  --with-pdo-odbc=generic,dir,libname,ldflags,cflags

                                When build as shared the extension filename is always pdo_odbc.so
      --with-pdo-pgsql[=DIR]    PDO: PostgreSQL support.  DIR is the PostgreSQL base
                                install directory or the path to pg_config
      --without-pdo-sqlite[=DIR]
                                PDO: sqlite 3 support.  DIR is the sqlite base
                                install directory [BUNDLED]
      --with-pgsql[=DIR]      Include PostgreSQL support.  DIR is the PostgreSQL
                              base install directory or the path to pg_config
      --disable-posix         Disable POSIX-like functions
      --with-pspell[=DIR]     Include PSPELL support.
                              GNU Aspell version 0.50.0 or higher required



      --with-libedit[=DIR]    Include libedit readline replacement (CLI/CGI only)
      --with-readline[=DIR]   Include readline support (CLI/CGI only)
      --with-recode[=DIR]     Include recode support
      --disable-reflection    Disable reflection support
      --disable-session       Disable session support
      --with-mm[=DIR]           SESSION: Include mm support for session storage
      --enable-shmop          Enable shmop support
      --disable-simplexml     Disable SimpleXML support
      --with-libxml-dir=DIR     SimpleXML: libxml2 install prefix
      --with-snmp[=DIR]       Include SNMP support
      --with-openssl-dir[=DIR]  SNMP: openssl install prefix
      --enable-ucd-snmp-hack    SNMP: Enable UCD SNMP hack
      --enable-soap           Enable SOAP support
      --with-libxml-dir=DIR     SOAP: libxml2 install prefix
      --enable-sockets        Enable sockets support
      --disable-spl           Disable Standard PHP Library
      --without-sqlite        Do not include sqlite support.  DIR is the sqlite base
                              install directory [BUNDLED]
      --enable-sqlite-utf8      SQLite: Enable UTF-8 support for SQLite
      --with-regex=TYPE       regex library type: system, apache, php. [TYPE=php]
                              WARNING: Do NOT use unless you know what you are doing!
      --with-sybase[=DIR]     Include Sybase-DB support.  DIR is the Sybase home
                              directory [/home/sybase]
      --with-sybase-ct[=DIR]  Include Sybase-CT support.  DIR is the Sybase home
                              directory [/home/sybase]
      --enable-sysvmsg        Enable sysvmsg support
      --enable-sysvsem        Enable System V semaphore support
      --enable-sysvshm        Enable the System V shared memory support
      --with-tidy[=DIR]       Include TIDY support
      --disable-tokenizer     Disable tokenizer support
      --enable-wddx           Enable WDDX support
      --with-libxml-dir=DIR     WDDX: libxml2 install prefix
      --with-libexpat-dir=DIR   WDDX: libexpat dir for XMLRPC-EPI (deprecated)
      --disable-xml           Disable XML support
      --with-libxml-dir=DIR     XML: libxml2 install prefix
      --with-libexpat-dir=DIR   XML: libexpat install prefix (deprecated)
      --disable-xmlreader     Disable XMLReader support
      --with-libxml-dir=DIR     XMLReader: libxml2 install prefix
      --with-xmlrpc[=DIR]     Include XMLRPC-EPI support
      --with-libxml-dir=DIR     XMLRPC-EPI: libxml2 install prefix
      --with-libexpat-dir=DIR   XMLRPC-EPI: libexpat dir for XMLRPC-EPI (deprecated)
      --with-iconv-dir=DIR      XMLRPC-EPI: iconv dir for XMLRPC-EPI
      --disable-xmlwriter     Disable XMLWriter support
      --with-libxml-dir=DIR     XMLWriter: libxml2 install prefix
      --with-xsl[=DIR]        Include XSL support.  DIR is the libxslt base
                              install directory (libxslt >= 1.1.0 required)
      --enable-zip            Include Zip read/write support
      --with-zlib-dir[=DIR]     ZIP: Set the path to libz install prefix

    PEAR:

      --with-pear=DIR         Install PEAR in DIR [PREFIX/lib/php]
      --without-pear          Do not install PEAR

    Zend:

      --with-zend-vm=TYPE     Set virtual machine dispatch method. Type is
                              one of CALL, SWITCH or GOTO [TYPE=CALL]
      --enable-maintainer-zts Enable thread safety - for code maintainers only!!
      --disable-inline-optimization 
                              If building zend_execute.lo fails, try this switch
      --enable-zend-multibyte Compile with zend multibyte support

    TSRM:

      --with-tsrm-pth[=pth-config]
                              Use GNU Pth
      --with-tsrm-st          Use SGI's State Threads
      --with-tsrm-pthreads    Use POSIX threads (default)

    Libtool:

      --enable-shared[=PKGS]  build shared libraries [default=yes]
      --enable-static[=PKGS]  build static libraries [default=yes]
      --enable-fast-install[=PKGS]  optimize for fast installation [default=yes]
      --with-gnu-ld           assume the C compiler uses GNU ld [default=no]
      --disable-libtool-lock  avoid locking (might break parallel builds)
      --with-pic              try to use only PIC/non-PIC objects [default=use both]
      --with-tags[=TAGS]      include additional configurations [automatic]

      --with-gnu-ld           assume the C compiler uses GNU ld [default=no]

    */

# much left to do here... 

          mandatory =  { buildInputs = [ "flex" "bison"]; };

# SAPI modules:
          apxs2        =      { cfgOption = "--with-apxs2=\$apacheHttpd/bin/apxs";
                                pass = "apacheHttpd"; };

# Extensions 

          curl          =     { cfgOption = [ "--with-curl=${if args.curl != null then args.curl else throw "curl support in PHP not supported on this platform"}" "--with-curlwrappers"]; pass = "curl";};
          zlib          =     { cfgOption = "--with-zlib=${args.zlib}"; pass = "zlib"; };

          libxml2       =     { cfgOption = "--with-libxml-dir=\$libxml2";
                                pass = { inherit (args) libxml2; }; 
                              };
          no_libxml2    =     { cfgOption =  "--disable-libxml";
                              };

          postgresql   =      { cfgOption = "--with-pgsql=\$postgresql";
                                pass = { inherit (args) postgresql;}; };
          mysql        =      { cfgOption = "--with-mysql=\$mysql";
                                pass = { inherit (args) mysql;}; };

          mysqli       =      { cfgOption = "--with-mysqli=\$mysql/bin/mysql_config";
                                pass = { inherit (args) mysql;}; 
                              };

          mysqli_embedded  =  { cfgOption = "--enable-embedded-mysqli" ; depends = "mysqli"; };


          pdo_mysql   =       { cfgOption = "--with-pdo-mysql=\$mysql";
                                pass = { inherit (args) mysql; }; 
                              };
          no_pdo_mysql = { };

          /* default location is enough for now ?
            --with-mysql-sock[=DIR]   MySQL: Location of the MySQL unix socket pointer.
                                      If unspecified, the default locations are searched
          */

          /*
             Building xdebug withing php to be able to add the parameters to the ini file.. Ther should be a better way
            meta = { 
                    description = "debugging support for PHP";
                    homepage = http://xdebug.org;
                    license = "based on the PHP license - as is";
                    };
          */
          xdebug = { buildInputs = [ "automake" "autoconf" ];  
                     pass = { xdebug_src = args.fetchurl {
                          name = "xdebug-2.0.2.tar.gz";
                          url = "http://xdebug.org/link.php?url=xdebug202";
                          sha256 = "1h0bxvf8krr203fmk1k7izrrr81gz537xmd3pqh4vslwdlbhrvic";
                   };};};


    };

  defaults = [ "mysql" "mysqli" "pdo_mysql" "libxml2" "apxs2" ];
  optionals = [ "libxml2" "gettext" "postgresql" "zlib"];

  # Don't konw wether they should be default.. I use them - Marc


  extraAttrs = co : {
    name = "php_configurable-${version}";

    buildInputs = ( args.lib.getAttr [ "phpIncludes" ] [] args ) ++ co.buildInputs;

    configurePhase = ''
      iniFile=$out/etc/$name.ini
      [[ -z "$libxml2" ]] || export PATH=$PATH:$libxml2/bin
      ./configure --with-config-file-scan-dir=/etc --with-config-file-path=$iniFile --prefix=$out ${co.configureFlags}
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
cat >> $iniFile << EOF
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
EOF
      fi
    '';

    src = args.fetchurl {
      url = "http://nl.php.net/get/php-${version}.tar.bz2/from/this/mirror";
      sha256 = "18xv961924rkk66gdjcmk1mzbzgp2srbiq5jvbgyn6ahvxq1xb2w";
      name = "php-${version}.tar.bz2";
    };

    meta = { 
      description = "The PHP language runtime engine"; # : CLI, CGI and Apache2 SAPIs ? as well TODO 
      homepage = http://www.php.net/;
      license = "PHP-3";
    };

    patches = [./fix.patch];
  };
}) args
