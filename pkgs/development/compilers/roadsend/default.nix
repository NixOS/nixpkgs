{ composableDerivation, fetchurl, bigloo, curl, fcgi ? null, libxml2 ? null, mysql ? null }:

let edf = composableDerivation.edf; in

composableDerivation.composableDerivation {} {
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
  
  src = fetchurl {
    url = "http://code.roadsend.com/snaps/roadsend-php-20081210.tar.bz2";
    sha256 = "0yhpiik0dyayd964wvn2k0cq7b1gihx1k3qx343r2l7lla4mapsx";
  };

  # tell pcc where to find the fastcgi library 
  postInstall = " sed -e \"s=(ldflags fastcgi.*=(ldflags -l fastcgi -L \$fcgi)=\" -i \$out/etc/pcc.conf ";
  
  meta = {
    description = "A PHP to C compiler";
    homepage = http://www.roadsend.com;
    # you can choose one of the following licenses: 
    # Runtime license is LPGL 2.1
    license = ["GPL2"];
  };
}
