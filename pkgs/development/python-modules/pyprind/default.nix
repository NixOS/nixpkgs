{
  lib,
  fetchPypi,
  buildPythonPackage,
  psutil,
  pytest,
}:

buildPythonPackage rec {
  pname = "pyprind";
  version = "2.11.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyPrind";
    inherit version;
    hash = "sha256-433KtuGpyOCn8PzmX956eeLe2hx1qgFZEKSeITe1TL8=";
  };

  buildInputs = [ psutil ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test tests
  '';

  meta = {
    description = "Python Progress Bar and Percent Indicator Utility";
    homepage = "https://github.com/rasbt/pyprind";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
