{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lzfse";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m1stadev";
    repo = "lzfse";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-ER+Hr/WrGCB0uYwsSgB4U8sCPeZ4JlOHoeb5YEGUFFM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "lzfse" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/m1stadev/lzfse/releases/tag/${src.tag}";
    description = "Python bindings for the LZFSE reference implementation";
    homepage = "https://github.com/m1stadev/lzfse";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
