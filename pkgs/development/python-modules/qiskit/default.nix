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
  version = "0.6.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "601e8db4db470593b94a32495c6e90e2db11a9382817a34584520573a7b8cc38";
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
