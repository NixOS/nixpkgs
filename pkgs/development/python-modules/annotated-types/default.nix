{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "annotated-types";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "annotated-types";
    repo = "annotated-types";
    tag = "v${version}";
    hash = "sha256-I1SPUKq2WIwEX5JmS3HrJvrpNrKDu30RWkBRDFE+k9A=";
  };

  nativeBuildInputs = [ hatchling ];

  pythonImportsCheck = [ "annotated_types" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Reusable constraint types to use with typing.Annotated";
    homepage = "https://github.com/annotated-types/annotated-types";
    changelog = "https://github.com/annotated-types/annotated-types/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
