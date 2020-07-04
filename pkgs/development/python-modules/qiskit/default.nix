{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
  # Python Inputs
, qiskit-aer
, qiskit-aqua
, qiskit-ibmq-provider
, qiskit-ignis
, qiskit-terra
  # Check Inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qiskit";
  # NOTE: This version denotes a specific set of subpackages. See https://qiskit.org/documentation/release_notes.html#version-history
  version = "0.19.6";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit";
    rev = version;
    sha256 = "0liby6ffgrla6wr4k742qkg8m80im372p6hmr4gkz47nmc76zy1i";
  };

  propagatedBuildInputs = [
    qiskit-aer
    qiskit-aqua
    qiskit-ibmq-provider
    qiskit-ignis
    qiskit-terra
  ];

  checkInputs = [ pytestCheckHook ];
  dontUseSetuptoolsCheck = true;
  # following doesn't work b/c they are distributed across different nix sitePackages dirs. Tested with pytest though.
  pythonImportsCheck = [ "qiskit" "qiskit.circuit" "qiskit.ignis" "qiskit.providers.aer" "qiskit.aqua" ];

  meta = {
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/QISKit/qiskit/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drewrisinger pandaman ];
  };
}
