{ stdenv, fetchFromGitHub, mcpp, bzip2, expat, openssl, db5 }:

stdenv.mkDerivation rec {
  name = "zeroc-ice-${version}";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "zeroc-ice";
    repo = "ice";
    rev = "v${version}";
    sha256 = "05xympbns32aalgcfcpxwfd7bvg343f16xpg6jv5s335ski3cjy2";
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
    homepage = http://www.zeroc.com/ice.html;
    description = "The internet communications engine";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
