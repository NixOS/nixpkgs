{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "ast-comments";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "t3rn0";
    repo = "ast-comments";
    tag = finalAttrs.version;
    hash = "sha256-Ji0nFjoNAtLQk7334GYZpe+TNn6+M9h1meJeI5v82M0=";
  };
  pyproject = true;
  build-system = [ poetry-core ];
  meta = {
    description = "A Python extension to the built-in `ast` module that preserves comments in the Abstract Syntax Tree. This library finds comments in source code and includes them as nodes in the parsed AST.";
    homepage = "https://github.com/t3rn0/ast-comments";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ n0099 ];
  };
})
