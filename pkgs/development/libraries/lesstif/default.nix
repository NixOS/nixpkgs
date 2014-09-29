{stdenv, fetchurl, xlibsWrapper, libXp, libXau}:

stdenv.mkDerivation {
  name = "lesstif-0.95.0-p2";
  src = fetchurl {
    url = mirror://sourceforge/lesstif/lesstif-0.95.2.tar.bz2;
    sha256 = "1qzpxjjf7ri1jzv71mvq5m9g8hfaj5yzwp30rwxlm6n2b24a6jpb";
  };
  buildInputs = [xlibsWrapper];
  propagatedBuildInputs = [libXp libXau];

  # The last stable release of lesstif was in June 2006. These
  # patches fix a number of later issues - in particular the 
  # render_table_crash shows up in 'arb'. The same patches appear
  # in Debian, so we assume they have been sent upstream.
  #
  patches = [
    ./c-missing_xm_h.patch        
    ./c-render_table_crash.patch 
    ./c-xpmpipethrough.patch
    ];
}
