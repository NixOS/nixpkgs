{ stdenv, fetchFromGitHub, mcpp, bzip2, expat, openssl, db5 }:

stdenv.mkDerivation rec {
  name = "zeroc-ice-${version}";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "zeroc-ice";
    repo = "ice";
    rev = "v${version}";
    sha256 = "044511zbhwiach1867r3xjz8i4931wn7c1l3nz4kcpgks16kqhhz";
  };

  buildInputs = [ mcpp bzip2 expat openssl db5 ];

  buildPhase = ''
    cd cpp
    make -j $NIX_BUILD_CORES OPTIMIZE=yes
  '';

  installPhase = ''
    make -j $NIX_BUILD_CORES prefix=$out install
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://www.zeroc.com/ice.html";
    description = "The internet communications engine";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
