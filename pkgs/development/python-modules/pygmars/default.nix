{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygmars";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "pygmars";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AbBhWR9ycOFrxS7Vz0bSsSyS3FEEm2bXJAvMhIba6XQ=";
  };

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pygmars" ];

  meta = {
    description = "Python lexing and parsing library";
    homepage = "https://github.com/nexB/pygmars";
    changelog = "https://github.com/aboutcode-org/pygmars/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
