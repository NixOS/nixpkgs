{ lib
, buildPythonPackage
, fetchFromGitHub
, unittestCheckHook
, pytz
, pyyaml
, argparse
}:

buildPythonPackage rec {
  pname = "pydateinfer";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wdm0006";
    repo = "dateinfer";
    rev = "${version},"; # yes the comma is required, this is correct name of git tag
    hash = "sha256-0gy7wfT/uMTmpdIF2OPGVeUh+4yqJSI2Ebif0Lf/DLM=";
  };

  propagatedBuildInputs = [
    pytz
  ];

  preCheck = "cd dateinfer";
  nativeCheckInputs = [
    unittestCheckHook
    pyyaml
    argparse
  ];
  pythonImportsCheck = [ "dateinfer" ];

  meta = with lib; {
    description = "Infers date format from examples";
    homepage = "https://pypi.org/project/pydateinfer/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
