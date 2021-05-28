{ lib, fetchPypi, buildPythonPackage, pythonOlder
, flake8-polyfill
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "pep8-naming";
  version = "0.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0937rnk3c2z1jkdmbw9hfm80p5k467q7rqhn6slfiprs4kflgpd1";
  };

  propagatedBuildInputs = [
    flake8-polyfill
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  meta = with lib; {
    homepage = "https://github.com/PyCQA/pep8-naming";
    description = "Check PEP-8 naming conventions, plugin for flake8";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
