{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools-scm,
  docutils,
  pyparsing,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "amply";
  version = "0.1.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-YUIRA8z44QZnFxFf55F2ENgx1VHGjTGhEIdqW2x4rqQ=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    docutils
    pyparsing
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "amply" ];

  meta = {
    homepage = "https://github.com/willu47/amply";
    description = ''
      Allows you to load and manipulate AMPL/GLPK data as Python data structures
    '';
    maintainers = with lib.maintainers; [ ris ];
    license = lib.licenses.epl10;
  };
})
