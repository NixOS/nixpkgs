{ lib
, buildPythonPackage
, fetchFromGitLab
, fetchFromGitHub
, pythonOlder
, setuptools
, dataclasses-json
, deprecated
, pytestCheckHook
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
  version = "1.16.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitLab {
    owner = "dodgyville";
    repo = "pygltflib";
    rev = "da1c687f5ea88d6063616857d54d195fa0739b37";  # no tags in repo, only on PyPI
    hash = "sha256-aoYVglpQ0Qaq6gEqZ455GlkL2/C1Q5YjQASVLplsWbs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    dataclasses-json
    deprecated
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
  preCheck = ''
    ln -s ${gltf-sample-models} glTF-Sample-Models
  '';

  pythonImportsCheck = [ "pygltflib" ];

  meta = with lib; {
    description = "Module for reading and writing basic glTF files";
    homepage = "https://gitlab.com/dodgyville/pygltflib";
    changelog = "https://gitlab.com/dodgyville/pygltflib/-/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
