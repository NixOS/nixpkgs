{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "argparse-addons";
  version = "0.8.0";

  src = fetchPypi {
    pname = "argparse_addons";
    inherit version;
    sha256 = "sha256-uwiBB5RNM56NLnCnYwXd41FUTixb3rrxwttWrS5tzeg=";
  };

  pythonImportsCheck = [ "argparse_addons" ];

  meta = with lib; {
    description = "Additional Python argparse types and actions";
    homepage = "https://github.com/eerimoq/argparse_addons";
    license = licenses.mit;
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}
