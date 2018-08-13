{ lib
, buildPythonPackage
, fetchPypi
, requests
, requests_ntlm
}:

buildPythonPackage rec {
  pname = "IBMQuantumExperience";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed164685ab743a4b216275f147227568ce27077068af33d0bd9a301ab1639e6e";
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
