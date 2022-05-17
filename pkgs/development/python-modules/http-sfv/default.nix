{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "http-sfv";
  version = "0.9.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mnot";
    repo = "http_sfv";
    rev = "http_sfv-${version}";
    hash = "sha256-S+cbcDx+cXwN2TpfiUpr6xK1GFRxSYgfHdUavfzeyAE=";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  # Tests require external data (https://github.com/httpwg/structured-field-tests)
  doCheck = false;

  pythonImportsCheck = [
    "http_sfv"
  ];

  meta = with lib; {
    description = "Module to parse and serialise HTTP structured field values";
    homepage = "https://github.com/mnot/http_sfv";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
