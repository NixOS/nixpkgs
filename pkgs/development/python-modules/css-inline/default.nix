{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  rustPlatform,

  # native darwin dependencies
  libiconv,

  # tests
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "css-inline";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Stranger6667";
    repo = "css-inline";
    rev = "python-v${version}";
    hash = "sha256-js9n+m5xDlzxMbXtN74klS0rjTCsHL3LhVAp0tx48b0=";
  };

  postPatch = ''
    cd bindings/python
    ln -s ${./Cargo.lock} Cargo.lock

    # don't rebuild std
    rm .cargo/config.toml
  '';

  # call `cargo build --release` in bindings/python and copy the
  # resulting lock file
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    postPatch = ''
      cd bindings/python
      ln -s ${./Cargo.lock} Cargo.lock
    '';
    hash = "sha256-4DVLcJrK2at1vlThey0N97IWFHd1NM2MEXXA74BYfZs=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  pythonImportsCheck = [ "css_inline" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests =
    [
      # fails to connect to local server
      "test_cache"
      "test_remote_stylesheet"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
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
