{ lib
, stdenv
, toPythonModule
, fetchFromGitHub
, cmake
, boost

# Python package dependencies:
, matplotlib
, numba
, scikit-learn
, scipy
}:

let
  version = "2.6";
  src = fetchFromGitHub {
    owner = "esa";
    repo = "pykep";
    rev = "v${version}";
    sha256 = "sha256-iqCge8WX3WEFbf4BmCHU0EV3HFv1O8L7CNNt2q88yfc=";
  };

  mkMetaWithSuffix = suffix: with lib; {
    description = "scientific library providing basic tools for research in interplanetary trajectory design (${suffix})";
    homepage = "https://esa.github.io/pykep";
    license = licenses.gpl3;
    maintainers = with maintainers; [ nh2 ];
  };

  # Note [split-pykep]:
  #
  # The package is split into 2 parts: The C++ "keplerian_toolbox",
  # and the Python "pykep", controlled by the CMake variables
  #     -DPYKEP_BUILD_KEP_TOOLBOX=yes/no
  #     -DPYKEP_BUILD_PYKEP=yes/no
  # as described on:
  # https://esa.github.io/pykep/installation.html#installation-from-source
  #
  # > They cannot be on at the same time, and only one must be chosen.
  # see: # https://github.com/esa/pykep/blob/6425e53f0efd74997a7ad6873791f355e2ae2e93/CMakeLists.txt#L19-L20
  #
  # The dependencies are taken from:
  # https://esa.github.io/pykep/installation.html#dependencies

  keplerian_toolbox = stdenv.mkDerivation rec {
    pname = "keplerian_toolbox";

    inherit version;
    inherit src;

    cmakeFlags = [
      # From:
      #     https://esa.github.io/pykep/installation.html#installation-from-source
      "-DBoost_NO_BOOST_CMAKE=ON"

      # Part 1 from [split-pykep]
      "-DPYKEP_BUILD_KEP_TOOLBOX=yes"
      "-DPYKEP_BUILD_PYKEP=no"
      "-DPYKEP_BUILD_SPICE=yes"
    ];

    nativeBuildInputs = [
      cmake
    ];

    buildInputs = [
      boost
    ];

    doCheck = true;

    meta = mkMetaWithSuffix "C++ part";
  };

  pykep = toPythonModule (stdenv.mkDerivation rec {
    pname = "pykep";

    inherit version;
    inherit src;

    cmakeFlags = [
      # From:
      #     https://esa.github.io/pykep/installation.html#installation-from-source
      "-DBoost_NO_BOOST_CMAKE=ON"

      # Part 2 from https://esa.github.io/pykep/installation.html#installation-from-source
      "-DPYKEP_BUILD_KEP_TOOLBOX=no"
      "-DPYKEP_BUILD_PYKEP=yes"
      "-DPYKEP_BUILD_TESTS=no"
    ];

    nativeBuildInputs = [
      cmake
    ];

    buildInputs = [
      keplerian_toolbox
    ];

    propagatedBuildInputs = [
      boost
      matplotlib
      numba
      scikit-learn
      scipy
    ];

    doCheck = true;

    pythonImportsCheck = [ "pykep" ];

    meta = mkMetaWithSuffix "C++ part";
  });
in
  pykep
