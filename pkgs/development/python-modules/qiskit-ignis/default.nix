{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, numpy
, qiskit-terra
, scipy
  # Check Inputs
, pytestCheckHook
, qiskit-aer
}:

buildPythonPackage rec {
  pname = "qiskit-ignis";
  version = "0.2.0";

  disabled = pythonOlder "3.5";

  # Pypi's tarball doesn't contain tests
  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = version;
    sha256 = "08a60xk5dq5wmqc23r4hr2v2nsf9hs0ybz832vbnd6d80dl6izyc";
  };

  patches = [
    # Update tests for compatibility with qiskit-aer 0.4 (#342). Remove in version > 0.2.0
    (fetchpatch {
      url = "https://github.com/Qiskit/qiskit-ignis/commit/d78c494579f370058e68e360f10149db81b52477.patch";
      sha256 = "0ygkllf95c0jfvjg7gn399a5fd0wshsjpcn279kj7855m8j306h6";
    })
    # Fix statevector test over-eager validation (PR #333)
    (fetchpatch {
      url = "https://github.com/Qiskit/qiskit-ignis/commit/7cc8eb2e852b383ea429233fa43d3728931f1707.patch";
      sha256 = "0mdygykilg4qivdaa731z3y56l3ax4jp1sil9npqv0gn4p03c9g5";
    })
  ];

  propagatedBuildInputs = [
    numpy
    qiskit-terra
    scipy
  ];

  # Tests
  pythonImportsCheck = [ "qiskit.ignis" ];
  dontUseSetuptoolsCheck = true;
  preCheck = ''export HOME=$TMPDIR'';
  checkInputs = [
    pytestCheckHook
    qiskit-aer
  ];

  meta = with lib; {
    description = "Qiskit tools for quantum hardware verification, noise characterization, and error correction";
    homepage = "https://github.com/QISKit/qiskit-ignis";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
