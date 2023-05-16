{ lib
, astropy
, astropy-extension-helpers
, astropy-healpix
, buildPythonPackage
, cython
, fetchPypi
, numpy
<<<<<<< HEAD
, oldest-supported-numpy
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest-astropy
, pytestCheckHook
, pythonOlder
, scipy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "reproject";
  version = "0.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OKxPPKcVVrEVUGR8Zaphn7ur9HOuqQKa9gnMo2RQQME=";
  };

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "cython==" "cython>="
  '';

  nativeBuildInputs = [
    astropy-extension-helpers
    cython
    numpy
    oldest-supported-numpy
=======
  nativeBuildInputs = [
    astropy-extension-helpers
    cython
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    setuptools-scm
  ];

  propagatedBuildInputs = [
    astropy
    astropy-healpix
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytest-astropy
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "build/lib*"
    # Avoid failure due to user warning: Distutils was imported before Setuptools
    "-p no:warnings"
    # Uses network
    "--ignore build/lib*/reproject/interpolation/"
  ];

  pythonImportsCheck = [
    "reproject"
  ];

  meta = with lib; {
    description = "Reproject astronomical images";
    homepage = "https://reproject.readthedocs.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smaret ];
  };
}
