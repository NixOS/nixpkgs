{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  cython,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "openstep-plist";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "openstep_plist";
    inherit version;
    hash = "sha256-2vOGZSrghrzosYeExZqCUlI/rKOx3th2u/OTWU2GK3g=";
  };

  build-system = [
    cython
    setuptools
    setuptools-scm
  ];

  patches = [
    (fetchpatch {
      name = "openstep-plist-cpython-3.1-compat.patch";
      url = "https://github.com/fonttools/openstep-plist/commit/5467a2c3bed3004b79c70b5b288f33293c96742b.patch";
      hash = "sha256-dKZgthvPgdnCKA0o70TBtvipwnBr4wcayvK8SFqwrbY=";
    })
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
