{ stdenv
, isPy3k
, buildPythonPackage
, fetchPypi
, fetchurl
, python
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
, cmake
, llvmPackages 
}:

buildPythonPackage rec {
  pname = "qiskit";
  version = "0.5.5";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "81ce452cc69e55e1e6684cc5127cf477d6f0751e30522a3ae59ca2fc36610575";
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
