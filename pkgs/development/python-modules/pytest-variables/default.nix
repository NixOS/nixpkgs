{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytest,
  hjson,
  toml,
  pytestCheckHook,
  pyyaml,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytest-variables";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-variables";
    tag = version;
    hash = "sha256-adKoE3td12JtF2f6/1/+TlSIy4i6gRDmeeWalsE6B/w=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  buildInput = [ pytest ];

  optional-dependencies = {
    hjson = [ hjson ];
    toml = [ toml ];
    yaml = [ pyyaml ];
  };

<<<<<<< HEAD
  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;
=======
  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [ "pytest_variables" ];

  meta = {
    description = "Plugin for providing variables to pytest tests/fixtures";
    homepage = "https://github.com/pytest-dev/pytest-variables";
    changelog = "https://github.com/pytest-dev/pytest-variables/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
