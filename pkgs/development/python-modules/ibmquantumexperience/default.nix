{ lib
, buildPythonPackage
, fetchPypi
, requests
, requests_ntlm
}:

buildPythonPackage rec {
  pname = "IBMQuantumExperience";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2a5662d7457c297af0751985979e64a88569beb07cfedad0ce1dfa5a7237842";
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
