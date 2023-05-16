<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, cmake
, buildExamples ? false
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.5.0";
=======
{lib, stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  version = "1.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "nanoflann";

  src = fetchFromGitHub {
    owner = "jlblancoc";
    repo = "nanoflann";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-vPLL6l4sFRi7nvIfdMbBn/gvQ1+1lQHlZbR/2ok0Iw8=";
=======
    rev = "v${version}";
    sha256 = "sha256-NcewcNQcI1CjMNibRF9HCoE2Ibs0/Hy4eOkJ20W3wLo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
<<<<<<< HEAD
    "-DBUILD_EXAMPLES=${if buildExamples then "ON" else "OFF"}"
=======
    "-DBUILD_EXAMPLES=OFF"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = "https://github.com/jlblancoc/nanoflann";
<<<<<<< HEAD
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
=======
    license = lib.licenses.bsd2;
    description = "Header only C++ library for approximate nearest neighbor search";
    platforms = lib.platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
