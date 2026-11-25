{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pygmars";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aboutcode-org";
    repo = "pygmars";
    tag = "v${version}";
    # export-subst prevents reproducibility
    postFetch = ''
      sed -i /fallback_version/d "$out/pyproject.toml"
    '';
    hash = "sha256-0Qy5epvkw+2z3y67HbR8TfVpgb9qxdglHTvmtSJDkCs=";
  };

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pygmars" ];

  meta = {
    description = "Python lexing and parsing library";
    homepage = "https://github.com/aboutcode-org/pygmars";
    changelog = "https://github.com/aboutcode-org/pygmars/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
