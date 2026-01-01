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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "ULID implementation for Python";
    mainProgram = "ulid";
    homepage = "https://github.com/mdomke/python-ulid";
    changelog = "https://github.com/mdomke/python-ulid/blob/${src.tag}/CHANGELOG.rst";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
