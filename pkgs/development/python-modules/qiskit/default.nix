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
, cmake
, llvmPackages 
}:

buildPythonPackage rec {
  pname = "qiskit";
  version = "0.5.7";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5a2c6c074f8479dc83d1d599dfebf2363402a182835b8fa5742804055148b17";
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
