{ lib
, isPy3k
, buildPythonPackage
, fetchPypi
, jsonschema
, marshmallow
, marshmallow-polyfield
, networkx
, numpy
, pillow
, ply
, psutil
, requests
, requests_ntlm
, scipy
, sympy
, IBMQuantumExperience
, vcrpy
, jupyter
, python
}:

buildPythonPackage rec {
  pname = "qiskit-terra";
  version = "0.7.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9cc57da08896627d0f34cf6ae76bd3358a5e6e155f612137ff343dd787134720";
  };

  propagatedBuildInputs = [
    jsonschema
    marshmallow
    marshmallow-polyfield
    networkx
    numpy
    pillow
    ply
    psutil
    requests
    requests_ntlm
    scipy
    sympy
    IBMQuantumExperience
  ];

  checkInputs = [
    vcrpy
    jupyter
  ];

  checkPhase = "QISKIT_TESTS=skip_online ${python.interpreter} -m unittest discover -s test";

  meta = {
    description = "A library for creating, manipulating, and executing quantum circuits";
    homepage = https://github.com/Qiskit/qiskit-terra;

    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pandaman
    ];
  };
}
