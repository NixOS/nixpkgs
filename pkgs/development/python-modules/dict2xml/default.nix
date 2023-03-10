{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "dict2xml";
  version = "1.7.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "delfick";
    repo = "python-dict2xml";
    rev = "refs/tags/release-${version}";
    hash = "sha256-Ara+eWaUQv4VuzuVrpb5mjMXHHCxydS22glLsYz+UE0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Tests are inplemented in a custom DSL (RSpec)
  doCheck = false;

  pythonImportsCheck = [
    "dict2xml"
  ];

  meta = with lib; {
    description = "Library to convert a Python dictionary into an XML string";
    homepage = "https://github.com/delfick/python-dict2xml";
    changelog = "https://github.com/delfick/python-dict2xml/releases/tag/release-${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
