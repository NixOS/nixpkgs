{
  lib,
  buildPythonPackage,
  distro,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "ruyaml";
  version = "0.92.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = "ruyaml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UurUbq0wq0fob2Xv3O3cpSkUX1QqYm2cXMcsH3FB+1c=";
  };

  postPatch = ''
    # https://github.com/pycontribs/ruyaml/pull/107
    substituteInPlace pyproject.toml \
      --replace '"pip >= 19.3.1",' "" \
      --replace '"setuptools_scm_git_archive >= 1.1",' ""
  '';

  build-system = [ setuptools-scm ];

  dependencies = [ distro ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  pythonImportsCheck = [ "ruyaml" ];

  disabledTests = [
    # Assertion error
    "test_issue_60"
    "test_issue_60_1"
    "test_issue_61"
    "test_qualified_name00"
  ];

  preCheck = ''
    # Without this, pytest treats _test as a package
    rm _test/__init__.py
  '';

  meta = {
    description = "YAML 1.2 loader/dumper package for Python";
    homepage = "https://ruyaml.readthedocs.io/";
    changelog = "https://github.com/pycontribs/ruyaml/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
