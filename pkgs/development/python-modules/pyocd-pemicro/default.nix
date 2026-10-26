{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pyocd,
  pypemicro,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyocd-pemicro";
  version = "1.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyocd";
    repo = "pyocd-pemicro";
    tag = "v${finalAttrs.version}";
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
    changelog = "https://github.com/pyocd/pyocd-pemicro/releases/tag/v${finalAttrs.version}";
    description = "PEMicro probe plugin for pyOCD";
    homepage = "https://github.com/pyocd/pyocd-pemicro";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
