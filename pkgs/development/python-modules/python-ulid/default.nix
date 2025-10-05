{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  pydantic,
  freezegun,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-ulid";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mdomke";
    repo = "python-ulid";
    tag = version;
    hash = "sha256-ZMz1LqGJDgaMq4BNU33OPOQfoXFFuwFGcplnqtXSOHA=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  optional-dependencies = {
    pydantic = [ pydantic ];
  };

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ]
  ++ optional-dependencies.pydantic;

  pythonImportsCheck = [ "ulid" ];

  meta = with lib; {
    description = "ULID implementation for Python";
    mainProgram = "ulid";
    homepage = "https://github.com/mdomke/python-ulid";
    changelog = "https://github.com/mdomke/python-ulid/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
