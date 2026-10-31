{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  comet-maths,
  obsarray,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "punpy";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "comet-toolkit";
    repo = "punpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-696Q34hwBhOP7hHQ5bDizmLSRBTHsVdqb65K7+6Y7PE=";
  };

  build-system = [
    setuptools
  ];

  # https://github.com/comet-toolkit/obsarray/issues/37#issuecomment-6465469822
  preBuild = ''
    substituteInPlace punpy/_version.py \
      --replace-fail "1.0.8" "1.1.0"
  '';

  dependencies = [
    comet-maths
    obsarray
  ];

  pythonImportsCheck = [
    "punpy"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Propagating UNcertainties in PYthon";
    homepage = "https://punpy.readthedocs.io/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
