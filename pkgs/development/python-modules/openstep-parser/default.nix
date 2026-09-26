{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "openstep-parser";
  version = "2.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kronenthaler";
    repo = "openstep-parser";
    tag = version;
    hash = "sha256-ivPvkvVWXw5ftaGvwBR+JxBIlisI0p6k3i/8V2HlaqQ=";
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
