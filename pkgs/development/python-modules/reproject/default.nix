{ lib
, astropy
, astropy-extension-helpers
, astropy-healpix
, buildPythonPackage
, cython
, fetchPypi
, numpy
, pytest-astropy
, pytestCheckHook
, pythonOlder
, scipy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "reproject";
  version = "0.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pXSUVeTrxtSqKTa286xdCAAFipg38iR4XSO6CRfWXtc=";
  };

  nativeBuildInputs = [
    astropy-extension-helpers
    cython
    setuptools-scm
  ];

  propagatedBuildInputs = [
    astropy
    astropy-healpix
    numpy
    scipy
  ];

  checkInputs = [
    pytest-astropy
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "build/lib*"
    # Avoid failure due to user warning: Distutils was imported before Setuptools
    "-p no:warnings"
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
