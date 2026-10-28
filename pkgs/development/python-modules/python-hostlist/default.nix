{
  lib,
  buildPythonPackage,
  fetchurl,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "python-hostlist";
  version = "2.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://www.nsc.liu.se/~kent/python-hostlist/python_hostlist-${finalAttrs.version}.tar.gz";
    hash = "sha256-4aCxjlJaX8pXPLmGJ5nxGz8r07p67HDE7Ni5U0G7ceo=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "hostlist" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python module for hostlist handling";
    homepage = "https://www.nsc.liu.se/~kent/python-hostlist/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
