{stdenv, fetchurl, libunwind}:

stdenv.mkDerivation rec {
  name = "google-perftools-1.8.3";
  src = fetchurl {
    url = "http://google-perftools.googlecode.com/files/${name}.tar.gz";
    sha256 = "0ncx3a8jl6n38q9bjnaz5sq96yb6yh99j3bl64k3295v9arl9mva";
  };
  buildInputs = [libunwind];
  meta = {
    description = "Fast, multi-threaded malloc() and nifty performance analysis tools.";
    platforms = stdenv.lib.platforms.linux;
  };
}
