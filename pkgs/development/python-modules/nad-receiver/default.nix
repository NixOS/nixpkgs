{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
  telnetlib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "nad-receiver";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joopert";
    repo = "nad_receiver";
    tag = finalAttrs.version;
    hash = "sha256-CViZZCX/3s/ZbRoJN3VfpG2Nt70eNnaN7k9nD1glfRE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyserial
    telnetlib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nad_receiver" ];

  meta = {
    description = "Python interface for NAD receivers";
    homepage = "https://github.com/joopert/nad_receiver";
    changelog = "https://github.com/joopert/nad_receiver/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
