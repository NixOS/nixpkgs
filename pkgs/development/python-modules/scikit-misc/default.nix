{ lib
, fetchPypi
, buildPythonPackage
, cython
, gfortran
<<<<<<< HEAD
, git
, meson-python
, pkg-config
, numpy
, openblas
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "scikit-misc";
  version = "0.2.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "scikit_misc";
    inherit version;
    hash = "sha256-rBTdTpNeRC/DSrHFg7ZhHUYD0G9IgoqFx+A+LCxYK7w=";
  };

  postPatch = ''
    patchShebangs .

    substituteInPlace pyproject.toml \
      --replace 'numpy==' 'numpy>='
  '';

  nativeBuildInputs = [
    cython
    gfortran
    git
    meson-python
    numpy
    pkg-config
    setuptools
    wheel
  ];

  buildInputs = [
    numpy
    openblas
  ];

=======
, pytestCheckHook
, numpy }:

buildPythonPackage rec {
  pname = "scikit-misc";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-93RqA0eBEGPh7PkSHflINXhQA5U8OLW6hPY/xQjCKRE=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov --cov-report=xml" ""
  '';

  nativeBuildInputs = [
    gfortran
  ];

  buildInputs = [
    cython
    numpy
  ];

  # Tests fail because of infinite recursion error
  doCheck = false;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "skmisc"
  ];

  meta = with lib; {
    description = "Miscellaneous tools for scientific computing";
    homepage = "https://github.com/has2k1/scikit-misc";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
