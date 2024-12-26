{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools-scm,
  pyocd,
  pypemicro,
}:

buildPythonPackage rec {
  pname = "pyocd-pemicro";
  version = "1.1.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyocd";
    repo = "pyocd-pemicro";
    rev = "refs/tags/v${version}";
    hash = "sha256-qi803s8fkrLizcCLeDRz7CTQ56NGLQ4PPwCbxiRigwc=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    pyocd
    pypemicro
  ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/pyocd/pyocd-pemicro/releases/tag/v${version}";
    description = "PEMicro probe plugin for pyOCD";
    homepage = "https://github.com/pyocd/pyocd-pemicro";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
