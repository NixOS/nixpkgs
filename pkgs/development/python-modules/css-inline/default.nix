{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  rustPlatform,

  # native darwin dependencies
  libiconv,
  Security,
  SystemConfiguration,

  # tests
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "css-inline";
  version = "0.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Stranger6667";
    repo = "css-inline";
    rev = "python-v${version}";
    hash = "sha256-2C+UbndhGQxIsPVaJOMu/WdLHcA2H1uuJrNMhafybmU=";
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
    hash = "sha256-FvkVwd681EhEHRJ8ip97moEkRE3VcuIPbi+F1SjXz8E=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    Security
    SystemConfiguration
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
