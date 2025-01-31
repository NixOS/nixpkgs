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
  version = "2.7.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mdomke";
    repo = "python-ulid";
    rev = "refs/tags/${version}";
    hash = "sha256-Z9rYqekhrYa8ab17AVmKyObvq4HTOij7+LMlvRSqUQM=";
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
  ] ++ optional-dependencies.pydantic;

  pythonImportsCheck = [ "ulid" ];

  meta = with lib; {
    description = "ULID implementation for Python";
    mainProgram = "ulid";
    homepage = "https://github.com/mdomke/python-ulid";
    changelog = "https://github.com/mdomke/python-ulid/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
