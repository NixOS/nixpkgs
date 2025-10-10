{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  packaging,
}:

buildPythonPackage rec {
  pname = "requirements-parser";
  version = "0.13.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "madpah";
    repo = "requirements-parser";
    tag = "v${version}";
    hash = "sha256-AwsLcHjPfP+cYpKCQVgIcyzUhnqeIBJ92QLR48E6EtI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    packaging
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "requirements" ];

  meta = with lib; {
    description = "Pip requirements file parser";
    homepage = "https://github.com/davidfischer/requirements-parser";
    changelog = "https://github.com/madpah/requirements-parser/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
