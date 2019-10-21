{ stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig, arrayfire }:

stdenv.mkDerivation rec {
  pname = "arrayfire-ml";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "arrayfire";
    repo = "arrayfire-ml";
    rev = "fde97a5bf157936c8d904d0c857c6cb3275ee527";
    sha256 = "0ij6g36zcxqgcyhcy28ycg7jf1hgw4p9hv5l3jmkzis0yqnxm346";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ arrayfire ];

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/LICENSES
    mkdir -p $out/share

    cp libafml.so* $out/lib/.
    cp -r include/ $out/.
    cp LICENSE $out/LICENSES/BSD\ 3-Clause.txt
    cp -r examples/ $out/share/.
  '';

  meta = with stdenv.lib; {
    description = "C and C++ machine learning library built on top of the ArrayFire library";
    longDescription = ''
      ArrayFire ML is a C and C++ machine learning library built on top of the ArrayFire library.
      This library leverages arrayfire's cross platform support to provide high performance machine learning algorithms for multi-core CPUs, NVIDIA and AMD GPUs, and other accelerators.
    '';
    license = licenses.bsd3;
    homepage = "https://arrayfire.com/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ chessai ];
  };
}
