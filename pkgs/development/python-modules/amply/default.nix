{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools-scm,
  docutils,
  pyparsing,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "amply";
  version = "0.1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Z1tzt9dhE922z3Q8wW7ZJbzMTnLvZpkfDHNyBkYys8k=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
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
}
