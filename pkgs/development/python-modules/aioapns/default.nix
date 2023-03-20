{ buildPythonPackage
, fetchPypi
, setuptools
, h2
, lib
, pyjwt
, pyopenssl
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioapns";
  version = "2.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3FMNIhIZrstPKTfHVmN+K28UR2G26HZ5S/JtXmaFk1c=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    h2
    pyopenssl
    pyjwt
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioapns" ];

  meta = with lib; {
    description = "An efficient APNs Client Library for Python/asyncio";
    homepage = "https://github.com/Fatal1ty/aioapns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
