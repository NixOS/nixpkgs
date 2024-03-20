{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub

# build-system
, rustPlatform

# native darwin dependencies
, libiconv
, Security
, SystemConfiguration

# tests
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "css-inline";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Stranger6667";
    repo = "css-inline";
    rev = "python-v${version}";
    hash = "sha256-hhjeOr7EJc4Tmn/eQ1vF0xChSIlgfSmtqi6s7WCUq00=";
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
    hash = "sha256-noYBSwCfdpuwb55toyx4K/16Z4A0NWjnMuzwTi5g8AU=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Security
    SystemConfiguration
  ];

  pythonImportsCheck = [
    "css_inline"
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # fails to connect to local server
    "test_remote_stylesheet"
  ] ++ lib.optionals (stdenv.isDarwin) [
    # pyo3_runtime.PanicException: event loop thread panicked
    "test_invalid_href"
  ];

  meta = with lib; {
    description = "Inline CSS into style attributes";
    homepage = "https://github.com/Stranger6667/css-inline";
    changelog = "https://github.com/Stranger6667/css-inline/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
