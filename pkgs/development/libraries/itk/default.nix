{ stdenv, fetchurl, fetchpatch, cmake, libX11, libuuid, xz, vtk }:

stdenv.mkDerivation rec {
  name = "itk-4.11.0";

  src = fetchurl {
    url = mirror://sourceforge/itk/InsightToolkit-4.11.0.tar.xz;
    sha256 = "0axvyds0gads5914g0m70z5q16gzghr0rk0hy3qjpf1k9bkxvcq6";
  };

  # Clang 4 dislikes signed comparisons of pointers against integers. Should no longer be
  # necessary once we get past ITK 4.11.
  patches = [ (fetchpatch {
    url    = "https://github.com/InsightSoftwareConsortium/ITK/commit/d1407a55910ad9c232f3d241833cfd2e59024946.patch";
    sha256 = "0h851afkv23fwgkibjss30fkbz4nkfg6rmmm4pfvkwpml23gzz7s";
  }) ];

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DModule_ITKIOMINC=ON"
    "-DModule_ITKVtkGlue=ON"
    "-DModule_ITKReview=ON"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake xz ];
  buildInputs = [ libX11 libuuid vtk ];

  meta = {
    description = "Insight Segmentation and Registration Toolkit";
    homepage = http://www.itk.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
