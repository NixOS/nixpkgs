{ lib
, buildPythonPackage
, fetchPypi
, requests
, requests_ntlm
}:

buildPythonPackage rec {
  pname = "IBMQuantumExperience";
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "480cce2ca285368432b7d00b9cd702a4f8a1c9d69914ba6f65e08099e151e407";
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
