{stdenv, fetchurl, xlibsWrapper, libXp, libXau}:

stdenv.mkDerivation {
  name = "lesstif-0.95.0-p2";
  src = fetchurl {
    url = mirror://sourceforge/lesstif/lesstif-0.95.0.tar.bz2;
    md5 = "ab895165c149d7f95843c7584b1c7ad4";
  };
  buildInputs = [xlibsWrapper];
  propagatedBuildInputs = [libXp libXau];

  # The last stable release of lesstif was in June 2006. These
  # patches fix a number of later issues - in particular the 
  # render_table_crash shows up in 'arb'. The same patches appear
  # in Debian, so we assume they have been sent upstream.
  #
  patches = [
    ./c-bad_integer_cast.patch    
    ./c-linkage.patch             
    ./c-unsigned_int.patch
    ./c-missing_xm_h.patch        
    ./c-xim_chained_list_crash.patch
    ./c-render_table_crash.patch 
    ./c-xpmpipethrough.patch
    ];
}
