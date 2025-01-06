{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "openstep-plist";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    pname = "openstep_plist";
    inherit version;
    hash = "sha256-Au6taO+57Ost4slTlwc86A/ImFXZerZRab2S/ENo5PI=";
  };

  build-system = [
    cython
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "openstep_plist" ];

  meta = {
    changelog = "https://github.com/fonttools/openstep-plist/releases/tag/v${version}";
    description = "Parser for the 'old style' OpenStep property list format also known as ASCII plist";
    homepage = "https://github.com/fonttools/openstep-plist";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.BarinovMaxim ];
  };
}
