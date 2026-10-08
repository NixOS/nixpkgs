{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "opentypespec";
  version = "1.9.2";
  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  src = fetchFromGitHub {
    owner = "simoncozens";
    repo = "opentypespec-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TTZZZVtIFMJNeC1R2pvE1dcCEx+U7mBtLq+kBDkI6+Q=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python library for OpenType specification metadata";
    homepage = "https://github.com/simoncozens/opentypespec-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      danc86
      jopejoe1
    ];
  };
})
