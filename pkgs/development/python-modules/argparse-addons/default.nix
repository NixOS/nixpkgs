{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "argparse-addons";
  version = "0.12.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "argparse_addons";
    inherit version;
    hash = "sha256-YyKg3NcGiH52MI0jE21bhtoOq3WigtxklnAdEhC0YK8=";
  };

  pythonImportsCheck = [ "argparse_addons" ];

  meta = {
    description = "Additional Python argparse types and actions";
    homepage = "https://github.com/eerimoq/argparse_addons";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      frogamic
      sbruder
    ];
  };
}
