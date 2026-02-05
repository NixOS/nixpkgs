{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
}:

buildPythonPackage rec {
  pname = "dict2xml";
  version = "1.7.7";
  pyproject = true;

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

  meta = {
    description = "Library to convert a Python dictionary into an XML string";
    homepage = "https://github.com/delfick/python-dict2xml";
    changelog = "https://github.com/delfick/python-dict2xml/releases/tag/release-${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ johnazoidberg ];
  };
}
