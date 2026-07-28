{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cexprtk";
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sBLkHco0u2iEsdUxmPW2ONP/Fe08p0fOVJLmzz3t4os=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cexprtk" ];

  meta = {
    description = "Mathematical expression parser, cython wrapper";
    homepage = "https://github.com/mjdrushton/cexprtk";
    changelog = "https://github.com/mjdrushton/cexprtk/blob/${version}/CHANGES.md";
    license = lib.licenses.cpl10;
    maintainers = with lib.maintainers; [ onny ];
  };
}
