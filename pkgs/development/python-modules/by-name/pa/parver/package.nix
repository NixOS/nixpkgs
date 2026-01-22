{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  attrs,
  pytestCheckHook,
  hypothesis,
  pretend,
  arpeggio,
}:

buildPythonPackage rec {
  pname = "parver";
  version = "0.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uf3h5ruc6fB+COnEvqjYglxeeOGKAFLQLgK/lRfrR3c=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    attrs
    arpeggio
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    pretend
  ];

  meta = {
    description = "Allows parsing and manipulation of PEP 440 version numbers";
    homepage = "https://github.com/RazerM/parver";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
