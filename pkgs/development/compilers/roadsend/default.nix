args:
let edf = args.lib.enableDisableFeature; in
( args.mkDerivationByConfiguration {
    flagConfig = {
      mandatory = { buildInputs = ["bigloo" "curl"]; };
    } // edf "pcre" "pcre" { } #support pcre extension [default=check]
      // edf "fcgi" "fcgi" { pass = "fcgi"; } #support FastCGI web backend [default=check]
      // edf "xml" "xml" { pass ="libxml2"; } #support xml extension [default=check]
      // edf "mysql" "mysql" { pass = "mysql"; } #support mysql extension [default=check]
      #// edf "sqlite3=[ARG]" "sqlite3=[ARG]" { } [>use SQLite 3 library [default=yes], optionally
                                #specify the prefix for sqlite3 library
      // edf "odbc" "odbc" { } #support ODBC extension [default=check]
      // edf "gtk" "gtk" { } #support PHP-GTK extension [default=no]
      // edf "gtk2" "gtk2" { }; #support PHP-GTK 2 extension [default=no]

    optionals = [ "libxml2" "gettext" "fcgi" ];
    extraAttrs = co : {
      name = "roadsend-2.9.3";

      src = args.fetchurl {
        url = "http://code.roadsend.com/snaps/roadsend-php-2.9.4.tar.bz2";
        sha256 = "0nw7rvrrwkss5cp6ws0m3q63q1mcyy27s8yjhy7kn508db1rgl9x";
      };

    # tell pcc where to find the fastcgi library 
      postInstall = " sed -e \"s=(ldflags fastcgi.*=(ldflags -l fastcgi -L \$fcgi)=\" -i \$out/etc/pcc.conf ";

    meta = { 
      description = "roadsend PHP -> C compiler";
      homepage = http://www.roadsend.com;
      # you can choose one of the following licenses: 
      # Runtime license is LPGL 2.1
      license = ["GPL2"];
    };
  };
} ) args
