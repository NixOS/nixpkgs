{ stdenv, fetchurl, x11, libXp, libXau }:

stdenv.mkDerivation {
  name = "lesstif-0.93.94";
  
  src = fetchurl {
    url = http://prdownloads.sourceforge.net/lesstif/lesstif-0.93.94.tar.bz2;
    sha256 = "0v4l46ill6dhhswsw1hk6rqyng98d85nsr214vhd2k0mfajpig1y";
  };
  
  buildInputs = [x11];
  
  propagatedBuildInputs = [libXp libXau];

  # This is an older release of lesstif which works with arb.
  patches =
    [ ./c-bad_integer_cast.patch    
      ./c-xim_chained_list_crash.patch
      ./c-render_table_crash.patch 
      ./stdint.patch
    ];
    
  meta = {
    priority = "5";
  };
}
