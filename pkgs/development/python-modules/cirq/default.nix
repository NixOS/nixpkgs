{ buildPythonPackage
, fetchpatch
, cirq-aqt
, cirq-core
, cirq-google
, cirq-ionq
, cirq-pasqal
, cirq-rigetti
, cirq-web
  # test inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cirq";
  inherit (cirq-core) version src meta;

  patches = [
    (fetchpatch {
      url = "https://github.com/quantumlib/Cirq/commit/b832db606e5f1850b1eda168a6d4a8e77d8ec711.patch";
      name = "pr-5330-prevent-implicit-packages.patch";
      sha256 = "sha256-HTEH3fFxPiBedaz5GxZjXayvoiazwHysKZIOzqwZmbg=";
    })
  ];

  propagatedBuildInputs = [
    cirq-aqt
    cirq-core
    cirq-ionq
    cirq-google
    cirq-rigetti
    cirq-pasqal
    cirq-web
  ];

  # pythonImportsCheck = [ "cirq" "cirq.Circuit" ];  # cirq's importlib hook doesn't work here
  checkInputs = [ pytestCheckHook ];

  # Don't run submodule or development tool tests
  disabledTestPaths = [
    "cirq-aqt"
    "cirq-core"
    "cirq-google"
    "cirq-ionq"
    "cirq-pasqal"
    "cirq-rigetti"
    "cirq-web"
    "dev_tools"
  ];

}
