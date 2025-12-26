{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  rpy2-rinterface,
  rpy2-robjects,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "3.6.4";
  format = "pyproject";
  pname = "rpy2";

  disabled = isPyPy;
  src = fetchPypi {
    inherit version pname;
    hash = "sha256-ok6N2lxf+MvSuOvRzPbxpaCldmI3AM+R4szpjUGnn9M=";
  };

  propagatedBuildInputs = [
    rpy2-rinterface
    rpy2-robjects
  ];

  pythonImportsCheck = [
    "rpy2"
  ];

  meta = {
    homepage = "https://rpy2.github.io/";
    description = "Python interface to R";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ joelmo ];
  };
}
