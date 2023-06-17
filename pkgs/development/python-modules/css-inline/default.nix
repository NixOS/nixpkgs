{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub

# build-system
, rustPlatform

# native darwin dependencies
, libiconv
, Security

# tests
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "css-inline";
  version = "0.8.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Stranger6667";
    repo = "css-inline";
    rev = "python-v${version}";
    hash = "sha256-VtWvzEqozbRo9OIcObdaRRqDq9Tcp0KxXOPZWO5qTeE=";
  };

  postPatch = ''
    cd bindings/python
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    postPatch = ''
      cd  bindings/python
      ln -s ${./Cargo.lock} Cargo.lock
    '';
    name = "${pname}-${version}";
    hash = "sha256-S8ebg5sMK7zoG84eAeXIWqDYuRVW9Mx9GJUAaKD9mxw=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  pythonImportsCheck = [
    "css_inline"
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Inline CSS into style attributes";
    homepage = "https://github.com/Stranger6667/css-inline";
    changelog = "https://github.com/Stranger6667/css-inline/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
