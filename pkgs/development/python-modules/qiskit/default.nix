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
  version = "0.7.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "63e7a7c3033fe955d715cc825b3fb61d27c25ad66e1761493ca2243b5dbfb4f9";
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
    # Needs to be updated and have its new dependencies added
    broken = true;
  };
}
