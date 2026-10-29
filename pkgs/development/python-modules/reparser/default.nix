{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage (finalAttrs: {
  pname = "reparser";
  version = "1.4.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xmikos";
    repo = "reparser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AX/qfyI6is5ie2qSEWpVRAM5xrQBlDMkFhJ4y0WBZxM=";
  };

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "reparser" ];

  meta = {
    description = "Simple regex-based lexer/parser for inline markup";
    homepage = "https://github.com/xmikos/reparser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
