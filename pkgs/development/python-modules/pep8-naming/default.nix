{ lib, fetchPypi, buildPythonPackage, pythonOlder
, flake8-polyfill
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "pep8-naming";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fmzccbmr0jn9ynamdb9ly2ai8qs5qfk8alfgnzr3fbjvpwsbd7k";
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
