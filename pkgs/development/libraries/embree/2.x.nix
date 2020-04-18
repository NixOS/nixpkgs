{ stdenv, fetchFromGitHub, cmake, pkgconfig, ispc, tbb, glfw,
openimageio, libjpeg, libpng, libpthreadstubs, libX11
}:

stdenv.mkDerivation {
  pname = "embree";
  version = "2.17.4";

  src = fetchFromGitHub {
    owner = "embree";
    repo = "embree";
    rev = "v2.17.4";
    sha256 = "0q3r724r58j4b6cbyy657fsb78z7a2c7d5mwdp7552skynsn2mn9";
  };

  cmakeFlags = [ "-DEMBREE_TUTORIALS=OFF" ];
  enableParallelBuilding = true;
  
  buildInputs = [ pkgconfig cmake ispc tbb glfw openimageio libjpeg libpng libX11 libpthreadstubs ];
  meta = with stdenv.lib; {
    description = "High performance ray tracing kernels from Intel"; 
    homepage = "https://embree.github.io/";
    maintainers = with maintainers; [ hodapp ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
