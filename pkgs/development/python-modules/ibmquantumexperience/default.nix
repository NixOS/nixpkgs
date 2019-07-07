{ lib
, buildPythonPackage
, fetchPypi
, requests
, requests_ntlm
}:

buildPythonPackage rec {
  pname = "IBMQuantumExperience";
  version = "2.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0szn743sbm3cs80982cf4994c1xcg6iz5xkhdbpm1kfv5qn1phja";
  };

  propagatedBuildInputs = [
    requests
    requests_ntlm
  ];

  # test requires an API token
  doCheck = false;

  meta = {
    description = "A Python library for the Quantum Experience API";
    homepage    = https://github.com/QISKit/qiskit-api-py;
    license     = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pandaman
    ];
  };
}
