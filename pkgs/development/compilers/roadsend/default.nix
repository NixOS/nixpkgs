args: with args;
let edf = composableDerivation.edf; in
composableDerivation.composableDerivation {
  initial = {
    name = "roadsend-2.9.3";
    buildInputs = [bigloo curl];
    flags = edf { name = "pcre"; }
         // edf { name = "fcgi"; enable = { inherit fcgi; }; }
         // edf { name = "xml"; enable = { buildInputs = [ libxml2 ]; }; }
         // edf { name = "mysql"; enable = { buildInputs = [ mysql ]; }; }
         // edf { name = "odbc"; };
         # // edf { name = "gtk"} }
         # // edf { name = "gtk2", enable = { buildInputs = [ mysql ]; } }
    cfg = {
      pcreSupport = true;
      fcgiSupport = true;
      xmlSupport = true;
      mysqlSupport = true;
    };
    src = args.fetchurl {
      url = "http://code.roadsend.com/snaps/roadsend-php-20081210.tar.bz2";
      sha256 = "0yhpiik0dyayd964wvn2k0cq7b1gihx1k3qx343r2l7lla4mapsx";
    };

#    http://code.roadsend.com/snaps/roadsend-php-testsuite-2.9.7.tar.bz2";
#   sha256 = "0rf0g9r0prla7daq3aif24d7dx0j01i35hcm8h5bbg3gvpfim463";

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
}
