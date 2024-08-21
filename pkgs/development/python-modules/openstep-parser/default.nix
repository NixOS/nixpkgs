{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "openstep-parser";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kronenthaler";
    repo = "openstep-parser";
    rev = "refs/tags/${version}";
    hash = "sha256-gvfzBLLaal0Vad3C4m4wIKwJpmlhewsK4A5yeN8l6qU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "openstep_parser" ];

  meta = {
    description = "OpenStep plist parser for Python";
    homepage = "https://github.com/kronenthaler/openstep-parser";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ilaumjd ];
  };
}
