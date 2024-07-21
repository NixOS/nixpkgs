{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
}:

buildPythonPackage rec {
  pname = "dict2xml";
  version = "1.7.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "delfick";
    repo = "python-dict2xml";
    rev = "refs/tags/release-${version}";
    hash = "sha256-GNvG1VFz/qkkTrKleMrq8n6kcIYtfhUlQMyCqH9uQzw=";
  };

  nativeBuildInputs = [ hatchling ];

  # Tests are inplemented in a custom DSL (RSpec)
  doCheck = false;

  pythonImportsCheck = [ "dict2xml" ];

  meta = with lib; {
    description = "Library to convert a Python dictionary into an XML string";
    homepage = "https://github.com/delfick/python-dict2xml";
    changelog = "https://github.com/delfick/python-dict2xml/releases/tag/release-${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
