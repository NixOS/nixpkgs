{ stdenv
, isPy3k
, buildPythonPackage
, fetchPypi
, qiskit-aer
, qiskit-terra
, python
}:

buildPythonPackage rec {
  pname = "qiskit";
  version = "0.7.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "63e7a7c3033fe955d715cc825b3fb61d27c25ad66e1761493ca2243b5dbfb4f9";
  };

  patches = [
    # Qiskit overrides the installation to deal with misconfiguration of dependency,
    # but we don't need it as Nix tracks the right dependency
    ./no-override.patch
  ];

  propagatedBuildInputs = [
    qiskit-aer
    qiskit-terra
  ];

  meta = {
    description = "Software for developing quantum computing programs";
    homepage    = https://github.com/Qiskit/qiskit;
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [
      pandaman
    ];
  };
}
