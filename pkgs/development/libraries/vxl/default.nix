{ stdenv, fetchFromGitHub, unzip, cmake, libtiff, expat, zlib, libpng, libjpeg }:
stdenv.mkDerivation {
  name = "vxl-1.17.0-nix1";

  src = fetchFromGitHub {
    owner = "vxl";
    repo = "vxl";
    rev = "777c0beb7c8b30117400f6fc9a6d63bf8cb7c67a";
    sha256 = "0xpkwwb93ka6c3da8zjhfg9jk5ssmh9ifdh1by54sz6c7mbp55m8";
  };

  buildInputs = [ cmake unzip libtiff expat zlib libpng libjpeg ];

  cmakeFlags = [
    # BUILD_OUL wants old linux headers for videodev.h, not available
    # in stdenv linux headers
    "-DBUILD_OUL=OFF"
    # BUILD_BRL fails to find open()
    "-DBUILD_BRL=OFF"
    "-DBUILD_CONTRIB=OFF"
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
    "-DCMAKE_CXX_FLAGS=-fPIC"
    "-DCMAKE_C_FLAGS=-fPIC"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "C++ Libraries for Computer Vision Research and Implementation";
    homepage = http://vxl.sourceforge.net/;
    license = "VXL License";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
