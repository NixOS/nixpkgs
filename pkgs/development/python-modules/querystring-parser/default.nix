{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "querystring-parser";
  version = "1.2.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "querystring_parser";
    inherit version;
    hash = "sha256-ZE/OHP/gUwRTtDqDo4CU2+QizLqMmy8qHAAoDhTKimI=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  # https://github.com/bernii/querystring-parser/issues/35
  doCheck = false;

  pythonImportsCheck = [ "querystring_parser" ];

  meta = with lib; {
    description = "Module to handle nested dictionaries";
    homepage = "https://github.com/bernii/querystring-parser";
    changelog = "https://github.com/bernii/querystring-parser/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ tbenst ];
  };
}
