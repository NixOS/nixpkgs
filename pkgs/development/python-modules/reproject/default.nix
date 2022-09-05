{ lib
, astropy
, astropy-extension-helpers
, astropy-healpix
, astropy-helpers
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
  version = "0.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Z54sY3R6GViTvMLHrJclrAZ1dH4/9bzIrgqDd9nFbJY=";
  };

  nativeBuildInputs = [
    astropy-extension-helpers
    astropy-helpers
    cython
    setuptools-scm
  ];

  propagatedBuildInputs = [
    astropy
    astropy-healpix
    astropy-helpers
    numpy
    scipy
  ];

  checkInputs = [
    pytest-astropy
    pytestCheckHook
  ];

  preCheck = ''
    cd build/lib*
  '';

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
