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
  version = "0.5.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a86014da4ea8fe057ad3b953b44e2342f2bae3e1f9ac0d5f5d51dd659c33accf";
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

  patches = [
    ./setup.py.patch
  ];

  meta = {
    description = "Quantum Software Development Kit for writing quantum computing experiments, programs, and applications";
    homepage    = https://github.com/QISKit/qiskit-sdk-py;
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [
      pandaman
    ];
  };
}
