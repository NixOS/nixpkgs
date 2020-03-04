{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, google_api_python_client
, matplotlib
, networkx
, numpy
, pandas
, pythonProtobuf  # pythonPackages.protobuf
, requests
, scipy
, sortedcontainers
, sympy
, typing-extensions
  # test inputs
, pytestCheckHook
, pytest-benchmark
, ply
, pydot
, pyyaml
, pygraphviz
}:

buildPythonPackage rec {
  pname = "cirq";
  version = "0.6.1";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "cirq";
    rev = "v${version}";
    sha256 = "0lhr2dka7vpz9xd6akxphrcv2b3ni2cgjywpc1r7qpqa5mrq1q7f";
  };

  # Cirq 0.6 requires networkx==2.3 only for optional qiskit dependency/test, disable this to avoid networkx version conflicts. https://github.com/quantumlib/Cirq/issues/2368
  # Cirq locks protobuf==3.8.0, but tested working with default pythonPackages.protobuf (3.7). This avoids overrides/pythonPackages.protobuf conflicts
  prePatch = ''
    substituteInPlace requirements.txt --replace "networkx==2.3" "networkx" \
      --replace "protobuf==3.8.0" "protobuf"

    # Fix sympy 1.5 test failures. Should be fixed in v0.7
    substituteInPlace cirq/optimizers/eject_phased_paulis_test.py --replace "phase_exponent=0.125 + x / 8" "phase_exponent=0.125 + x * 0.125"
    substituteInPlace cirq/contrib/quirk/cells/parse_test.py --replace "parse_formula('5t') == 5 * t" "parse_formula('5t') == 5.0 * t"
  '';

  propagatedBuildInputs = [
    google_api_python_client
    numpy
    matplotlib
    networkx
    pandas
    pythonProtobuf
    requests
    scipy
    sortedcontainers
    sympy
    typing-extensions
  ];

  doCheck = true;
  # pythonImportsCheck = [ "cirq" "cirq.Ciruit" ];  # cirq's importlib hook doesn't work here
  dontUseSetuptoolsCheck = true;
  checkInputs = [
    pytestCheckHook
    pytest-benchmark
    ply
    pydot
    pyyaml
    pygraphviz
  ];
  # TODO: enable op_serializer_test. Error is type checking, for some reason wants bool instead of numpy.bool_. Not sure if protobuf or internal issue
  pytestFlagsArray = [
    "--ignore=dev_tools"  # Only needed when developing new code, which is out-of-scope
    "--ignore=cirq/google/op_serializer_test.py"  # investigating in https://github.com/quantumlib/Cirq/issues/2727
  ];

  meta = with lib; {
    description = "A framework for creating, editing, and invoking Noisy Intermediate Scale Quantum (NISQ) circuits.";
    homepage = "http://github.com/quantumlib/cirq";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
