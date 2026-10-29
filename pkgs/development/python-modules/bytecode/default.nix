{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "bytecode";
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MatthieuDartiailh";
    repo = "bytecode";
    tag = finalAttrs.version;
    hash = "sha256-aO9SPn8PC9UMdaxsnOP0MUcxg5MWOl6jcYOBHWJU/z0=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bytecode" ];

  meta = {
    homepage = "https://github.com/vstinner/bytecode";
    description = "Python module to generate and modify bytecode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raboof ];
  };
})
