{ lib
, buildPythonPackage
<<<<<<< HEAD
, duckdb
, google-cloud-storage
=======
, fetchpatch
, duckdb
, google-cloud-storage
, mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, numpy
, pandas
, psutil
, pybind11
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  inherit (duckdb) pname version src patches;
  format = "setuptools";

<<<<<<< HEAD
  postPatch = ''
    # we can't use sourceRoot otherwise patches don't apply, because the patches apply to the C++ library
=======
  # we can't use sourceRoot otherwise patches don't apply, because the patches
  # apply to the C++ library
  postPatch = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cd tools/pythonpkg

    # 1. let nix control build cores
    # 2. unconstrain setuptools_scm version
    substituteInPlace setup.py \
      --replace "multiprocessing.cpu_count()" "$NIX_BUILD_CORES" \
      --replace "setuptools_scm<7.0.0" "setuptools_scm"
<<<<<<< HEAD

      # avoid dependency on mypy
      rm tests/stubs/test_stubs.py
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    pybind11
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    pandas
  ];

  nativeCheckInputs = [
    google-cloud-storage
<<<<<<< HEAD
=======
    mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    psutil
    pytestCheckHook
  ];

<<<<<<< HEAD
  disabledTests = [
    # tries to make http request
    "test_install_non_existent_extension"
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "duckdb"
  ];

  meta = with lib; {
    description = "Python binding for DuckDB";
    homepage = "https://duckdb.org/";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ cpcloud ];
=======
    maintainers = with maintainers; [ costrouc cpcloud ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
