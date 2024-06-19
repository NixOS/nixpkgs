{ buildPythonPackage
, fetchFromGitHub
, pythonOlder
, hatchling
, lib
}:


buildPythonPackage rec {
  pname = "python-jsonpath";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jg-rp";
    repo = "python-jsonpath";
    rev = "refs/tags/v${version}";
    hash = "sha256-DaxBs/Bljmj8L2SIqHfBnuhdaNLLTRdytRn3oWPl30I=";
  };

  build-system = [
    hatchling
  ];

  meta = with lib; {
    description = "A flexible JSONPath engine for Python with JSON Pointer and JSON Patch";
    homepage = "https://github.com/jg-rp/python-jsonpath";
    license = licenses.mit;
  };
}

