{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  dataclasses-json,
  deprecated,
  pytestCheckHook,
}:

let
  gltf-sample-models = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glTF-Sample-Models";
    rev = "d7a3cc8e51d7c573771ae77a57f16b0662a905c6";
    hash = "sha256-TxSg1O6eIiaKagcZUoWZ5Iw/tBKvQIoepRFp3MdVlyI=";
  };
in

buildPythonPackage rec {
  pname = "pygltflib";
  version = "1.16.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitLab {
    owner = "dodgyville";
    repo = "pygltflib";
    rev = "refs/tags/v${version}";
    hash = "sha256-rUAg05M5biVsdG2yEH0Olng/0jH1R/Jo5/+j4ToKkTI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    dataclasses-json
    deprecated
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  preCheck = ''
    ln -s ${gltf-sample-models} glTF-Sample-Models
  '';

  pythonImportsCheck = [ "pygltflib" ];

  meta = with lib; {
    description = "Module for reading and writing basic glTF files";
    homepage = "https://gitlab.com/dodgyville/pygltflib";
    changelog = "https://gitlab.com/dodgyville/pygltflib/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
