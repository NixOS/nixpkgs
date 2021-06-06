{ lib
, buildPythonPackage
, cssselect
, fetchPypi
, lxml
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyquery";
  version = "1.4.3";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "00p6f1dfma65192hc72dxd506491lsq3g5wgxqafi1xpg2w1xia6";
  };

  propagatedBuildInputs = [
    cssselect
    lxml
  ];

  # circular dependency on webtest
  doCheck = false;
  pythonImportsCheck = [ "pyquery" ];

  meta = with lib; {
    description = "A jquery-like library for Python";
    homepage = "https://github.com/gawel/pyquery";
    changelog = "https://github.com/gawel/pyquery/blob/${version}/CHANGES.rst";
    license = licenses.bsd0;
  };
}
