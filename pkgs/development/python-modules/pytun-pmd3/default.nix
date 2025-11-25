{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytun-pmd3";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doronz88";
    repo = "pytun-pmd3";
    tag = "v${version}";
    hash = "sha256-3x+z+O6isgVRbPK+INfG5nG/+Tb2CWvPHg4TosH91so=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "pytun_pmd3" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/doronz88/pytun-pmd3/releases/tag/${src.tag}";
    description = "TUN/TAP wrapper for Python with Darwin support";
    homepage = "https://github.com/doronz88/pytun-pmd3";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
