{ lib
<<<<<<< HEAD
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, scikit-build-core
, pybind11
, cmake
, LASzip
, ninja
, pythonOlder
=======
, buildPythonPackage
, fetchFromGitHub
, scikit-build-core
, distlib
, pytestCheckHook
, pyproject-metadata
, pathspec
, pybind11
, cmake
, LASzip
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "laszip-python";
<<<<<<< HEAD
  version = "0.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";
=======
  version = "0.2.1";

  format = "pyproject";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tmontaigu";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-MiPzL9TDCf1xnCv7apwdfcpkFnBRi4PO/atTQxqL8cw=";
  };

  patches = [
    # Removes depending on the cmake and ninja PyPI packages, since we can pass
    # in the tools directly, and scikit-build-core can use them.
    # https://github.com/tmontaigu/laszip-python/pull/9
    (fetchpatch {
      name = "remove-cmake-ninja-pypi-dependencies.patch";
      url = "https://github.com/tmontaigu/laszip-python/commit/17e648d04945fa2d095d6d74d58c790a4fcde84a.patch";
      hash = "sha256-k58sS1RqVzT1WPh2OVt/D4Y045ODtj6U3bUjegd44VY=";
    })
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-std=c++17";

  nativeBuildInputs = [
    cmake
    ninja
    pybind11
    scikit-build-core
  ] ++ scikit-build-core.optional-dependencies.pyproject;

  dontUseCmakeConfigure = true;

  buildInputs = [
    LASzip
  ];

=======
    sha256 = "sha256-ujKoUm2Btu25T7ZrSGqjRc3NR1qqsQU8OwHQDSx8grY=";
  };

  nativeBuildInputs = [
    scikit-build-core
    scikit-build-core.optional-dependencies.pyproject
    cmake
  ];

  buildInputs = [
    pybind11
    LASzip
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preBuild = ''
    cd ..
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # There are no tests
  doCheck = false;

  pythonImportsCheck = [ "laszip" ];

  meta = with lib; {
    description = "Unofficial bindings between Python and LASzip made using pybind11";
    homepage = "https://github.com/tmontaigu/laszip-python";
<<<<<<< HEAD
    changelog = "https://github.com/tmontaigu/laszip-python/blob/${src.rev}/Changelog.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}

