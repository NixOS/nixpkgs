{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  pytestCheckHook,
}:

let
  version = "2.6.3";
in
buildPythonPackage {
  pname = "iso639-lang";
  inherit version;
  pyproject = true;

  src = fetchPypi {
    pname = "iso639_lang";
    inherit version;
    hash = "sha256-B43bfNAYLcwENnaRrMgCLd9xWLbLCfCPeYr4I/qGQmU=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "iso639"
    "iso639.data"
  ];

  meta = {
    description = "Fast, comprehensive, ISO 639 library";
    homepage = "https://pypi.org/project/iso639-lang/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jfly ];
  };
}
