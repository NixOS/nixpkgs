{ lib
, stdenv
, fetchFromGitHub
, cmake
, buildExamples ? false
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.5.5";
  pname = "nanoflann";

  src = fetchFromGitHub {
    owner = "jlblancoc";
    repo = "nanoflann";
    rev = "v${finalAttrs.version}";
    hash = "sha256-a1XX1tvXfrPCar9EGMXzxLg2bXJaK85t2Bd8CworwFk=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_EXAMPLES" buildExamples)
  ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = "https://github.com/jlblancoc/nanoflann";
    description = "Header only C++ library for approximate nearest neighbor search";
    longDescription = ''
      nanoflann is a C++11 header-only library for building KD-Trees of datasets
      with different topologies: R2, R3 (point clouds), SO(2) and SO(3) (2D and
      3D rotation groups). No support for approximate NN is provided. nanoflann
      does not require compiling or installing. You just need to #include
      <nanoflann.hpp> in your code.

      This library is a fork of the flann library by Marius Muja and David
      G. Lowe, and born as a child project of MRPT. Following the original
      license terms, nanoflann is distributed under the BSD license. Please, for
      bugs use the issues button or fork and open a pull request.
    '';
    changelog = "https://github.com/jlblancoc/nanoflann/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
