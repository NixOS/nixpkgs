{ lib
, fetchPypi
, buildPythonPackage
, pyyaml
, requests
}:

buildPythonPackage rec {
  pname = "bc-detect-secrets";
  version = "1.4.8";

  propagatedBuildInputs = [
    pyyaml
    requests
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T26g5Om6X0SeTJeVblhtWO0/iI3YnTUg4kZPDZIaLJ4=";
  };

  meta = with lib; {
    description = "Tool for detecting secrets in the codebase";
    homepage = "https://github.com/bridgecrewio/detect-secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
