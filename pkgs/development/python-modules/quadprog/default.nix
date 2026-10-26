{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  numpy,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "quadprog";
  version = "0.1.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quadprog";
    repo = "quadprog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pSiDQsSxcSZ9Wphq9zltIGOxnfRn+YuKKiI1X7N6CGc=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
  ];

  meta = {
    homepage = "https://github.com/quadprog/quadprog";
    changelog = "https://github.com/quadprog/quadprog/releases/tag/v${finalAttrs.version}";
    description = "Quadratic Programming Solver";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ wegank ];
  };
})
