{ stdenv
, isPy3k
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, sympy
, matplotlib
, networkx
, ply
, pillow
, cffi
, requests
, requests_ntlm
, IBMQuantumExperience
, jsonschema
, psutil
, cmake
, llvmPackages 
}:

buildPythonPackage rec {
  pname = "qiskit";
  version = "0.7.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "08c7f7ccd32a5cb0c0a0c4f63d6ff068d659c9c0b51e2df6f2054e586e8bfa19";
  };

  buildInputs = [ cmake ]
    ++ stdenv.lib.optional stdenv.isDarwin llvmPackages.openmp;

  propagatedBuildInputs = [
    numpy
    matplotlib
    networkx
    ply
    scipy
    sympy
    pillow
    cffi
    requests
    requests_ntlm
    IBMQuantumExperience
    jsonschema
    psutil
  ];

  # Pypi's tarball doesn't contain tests
  doCheck = false;

  meta = {
    description = "Quantum Software Development Kit for writing quantum computing experiments, programs, and applications";
    homepage    = https://github.com/QISKit/qiskit-terra;
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [
      pandaman
    ];
  };
}
