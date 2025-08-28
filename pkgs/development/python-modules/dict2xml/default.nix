{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
}:

buildPythonPackage rec {
  pname = "dict2xml";
  version = "1.7.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "delfick";
    repo = "python-dict2xml";
    tag = "release-${version}";
    hash = "sha256-66ODdslXF6nWYqJku8cNG0RPK/YGEfbpHwVLLnSoDrk=";
  };

  nativeBuildInputs = [ hatchling ];

  # Tests are implemented in a custom DSL (RSpec)
  doCheck = false;

  pythonImportsCheck = [ "dict2xml" ];

  meta = with lib; {
    description = "Library to convert a Python dictionary into an XML string";
    homepage = "https://github.com/delfick/python-dict2xml";
    changelog = "https://github.com/delfick/python-dict2xml/releases/tag/release-${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
