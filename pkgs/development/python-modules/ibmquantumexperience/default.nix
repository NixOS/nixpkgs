{ lib
, buildPythonPackage
, fetchPypi
, requests
, requests_ntlm
}:

buildPythonPackage rec {
  pname = "IBMQuantumExperience";
  version = "1.9.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "78a7d9770fa2884d79d3c8b18f374644866e4d22ec151cf703053f7530bb7b7c";
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
