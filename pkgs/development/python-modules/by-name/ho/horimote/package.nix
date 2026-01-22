{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "horimote";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "benleb";
    repo = "horimote";
    tag = "v${version}";
    hash = "sha256-rEtE0Z/PV/n9pz2mLbHeREv/sl4SexTSOq2yx4LDnAo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "horimote" ];

  meta = {
    description = "Async API wrapper for Samsung's set-top boxes SMT-G7400 and SMT-G7401";
    homepage = "https://github.com/benleb/horimote";
    changelog = "https://github.com/benleb/horimote/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
