{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyuca";
  version = "1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jtauber";
    repo = "pyuca";
    rev = "v${version}";
    hash = "sha256-KIWk+/o1MX5J9cO7xITvjHrYg0NdgdTetOzfGVwAI/4=";
  };

  pythonImportsCheck = [ "pyuca" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "A Python implementation of the Unicode Collation Algorithm";
    homepage = "https://github.com/jtauber/pyuca";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
