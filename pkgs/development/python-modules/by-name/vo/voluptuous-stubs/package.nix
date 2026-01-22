{
  lib,
  buildPythonPackage,
  fetchPypi,
  mypy,
}:

buildPythonPackage rec {
  pname = "voluptuous-stubs";
  version = "0.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cPscCIJC8g4RAjJStWSM13+DH2ks2RDI+XE8wTXPjMg=";
  };

  nativeBuildInputs = [ mypy ];

  pythonImportsCheck = [ "voluptuous-stubs" ];

  doCheck = false;

  meta = {
    description = "Typing stubs for voluptuous";
    homepage = "https://github.com/ryanwang520/voluptuous-stubs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
