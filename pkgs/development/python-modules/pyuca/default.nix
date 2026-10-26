{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyuca";
  version = "1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jtauber";
    repo = "pyuca";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KIWk+/o1MX5J9cO7xITvjHrYg0NdgdTetOzfGVwAI/4=";
  };

  pythonImportsCheck = [ "pyuca" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Python implementation of the Unicode Collation Algorithm";
    homepage = "https://github.com/jtauber/pyuca";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
