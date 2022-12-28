{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, importlib-metadata
, pyyaml
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "markdown";
  version = "3.4.1";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    pname = "Markdown";
    inherit version;
    sha256 = "3b809086bb6efad416156e00a0da66fe47618a5d6918dd688f53f40c8e4cfeff";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  checkInputs = [ unittestCheckHook pyyaml ];

  pythonImportsCheck = [ "markdown" ];

  meta = with lib; {
    description = "A Python implementation of John Gruber's Markdown with Extension support";
    homepage = "https://github.com/Python-Markdown/markdown";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
