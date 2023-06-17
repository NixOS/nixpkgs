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
  version = "0.10.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Stranger6667";
    repo = "css-inline";
    rev = "python-v${version}";
    hash = "sha256-6KuA9eFQO2GUEok672D17OSq2Q9Dz6XcSRq7AO2kADg=";
  };

  postPatch = ''
    cd bindings/python
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  # call `cargo build --release` in bindings/python and copy the
  # resulting lock file
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    postPatch = ''
      cd bindings/python
      ln -s ${./Cargo.lock} Cargo.lock
    '';
    name = "${pname}-${version}";
    hash = "sha256-8Oty27rFsNo8/ZspbpJyDb1JNil2IWD5d3bJgbJnsTk=";
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
