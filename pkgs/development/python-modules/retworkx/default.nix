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
  version = "0.10.2";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "retworkx";
    rev = version;
    sha256 = "sha256-F2hcVUsuHcNfsg3rXYt/erc0zB6W7GdepVOReP3u4lg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
      inherit src;
      name = "${pname}-${version}";
      sha256 = "1ajzxwx0rrzzq844sbv986h4yg6krzhfagc0q6px3sbhnkm9s2i3";
  };

  nativeBuildInputs = with rustPlatform; [ cargoSetupHook maturinBuildHook ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  pythonImportsCheck = [ "retworkx" ];
  checkInputs = [
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
