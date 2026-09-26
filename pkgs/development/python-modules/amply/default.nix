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
  version = "0.1.7";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Z1tzt9dhE922z3Q8wW7ZJbzMTnLvZpkfDHNyBkYys8k=";
  };

  build-system = [ setuptools-scm ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools_scm[toml]>=10.1.2" "setuptools_scm"
  '';

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
