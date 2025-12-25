{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cexprtk";
  version = "0.4.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sBLkHco0u2iEsdUxmPW2ONP/Fe08p0fOVJLmzz3t4os=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cexprtk" ];

  meta = {
    description = "Mathematical expression parser, cython wrapper";
    homepage = "https://github.com/mjdrushton/cexprtk";
    license = lib.licenses.cpl10;
    maintainers = with lib.maintainers; [ onny ];
  };
}
