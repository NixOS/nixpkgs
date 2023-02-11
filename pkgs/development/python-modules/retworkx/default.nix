{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, rustPlatform
, fetchFromGitHub
, libiconv
  # Check inputs
, pytestCheckHook
, fixtures
, graphviz
, matplotlib
, networkx
, numpy
, pydot
}:

buildPythonPackage rec {
  pname = "retworkx";
  version = "0.11.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "retworkx";
    rev = version;
    hash = "sha256-o3XPMTaiFH5cBtyqtW650wiDBElLvCmERr2XwwdPO1c=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-Zhk4m+HNtimhPWfiBLi9dqJ0fp2D8d0u9k6ROG0/jBo=";
  };

  nativeBuildInputs = with rustPlatform; [ cargoSetupHook maturinBuildHook ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  pythonImportsCheck = [ "retworkx" ];
  nativeCheckInputs = [
    pytestCheckHook
    fixtures
    graphviz
    matplotlib
    networkx
    numpy
    pydot
  ];

  preCheck = ''
    export TESTDIR=$(mktemp -d)
    cp -r tests/ $TESTDIR
    pushd $TESTDIR
  '';
  postCheck = "popd";

  meta = with lib; {
    description = "A python graph library implemented in Rust.";
    homepage = "https://retworkx.readthedocs.io/en/latest/index.html";
    downloadPage = "https://github.com/Qiskit/retworkx/releases";
    changelog = "https://github.com/Qiskit/retworkx/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
