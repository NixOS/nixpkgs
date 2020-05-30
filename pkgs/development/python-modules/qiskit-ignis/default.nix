{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, python
, numpy
, qiskit-terra
, scikitlearn
, scipy
  # Check Inputs
, ddt
, pytestCheckHook
, qiskit-aer
}:

buildPythonPackage rec {
  pname = "qiskit-ignis";
  version = "0.3.0";

  disabled = pythonOlder "3.6";

  # Pypi's tarball doesn't contain tests
  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit-ignis";
    rev = version;
    sha256 = "16h04n9hxw669nq2ii16l6h75x8afisvp3j062n4c62kcqci0x4x";
  };

  # Fixed qiskit-ignis PR #385, figured this is easier than fetchpatch
  postPatch = ''
    substituteInPlace qiskit/ignis/logging/ignis_logging.py --replace "self.configure_logger" "self._configure_logger"
  '';

  propagatedBuildInputs = [
    numpy
    qiskit-terra
    scikitlearn
    scipy
  ];
  postInstall = "rm -rf $out/${python.sitePackages}/docs";  # this dir can create conflicts

  # Tests
  pythonImportsCheck = [ "qiskit.ignis" ];
  dontUseSetuptoolsCheck = true;
  preCheck = "export HOME=$TMPDIR";
  checkInputs = [
    ddt
    pytestCheckHook
    qiskit-aer
  ];
  # Test is in test/verification/test_entanglemet.py. test fails due to out-of-date calls & bad logic with this file since qiskit-ignis#328
  # see qiskit-ignis#386 for all issues. Should be able to re-enable in future.
  disabledTests = [ "TestEntanglement" ];

  meta = with lib; {
    description = "Qiskit tools for quantum hardware verification, noise characterization, and error correction";
    homepage = "https://qiskit.org/ignis";
    downloadPage = "https://github.com/QISKit/qiskit-ignis/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
