{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "argparse-addons";
  version = "0.12.0";

  src = fetchPypi {
    pname = "argparse_addons";
    inherit version;
    hash = "sha256-YyKg3NcGiH52MI0jE21bhtoOq3WigtxklnAdEhC0YK8=";
  };

  pythonImportsCheck = [ "argparse_addons" ];

  meta = with lib; {
    description = "Additional Python argparse types and actions";
    homepage = "https://github.com/eerimoq/argparse_addons";
    license = licenses.mit;
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}
