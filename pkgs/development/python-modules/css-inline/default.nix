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
<<<<<<< HEAD
  version = "0.19.0";
=======
  version = "0.18.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Stranger6667";
    repo = "css-inline";
    rev = "python-v${version}";
<<<<<<< HEAD
    hash = "sha256-IIZmSshcXC3H6kaH0iEiJEhDrZQtN0i5KNQ8H5aCGf4=";
=======
    hash = "sha256-sJOt7CX02uoECdki0iUZin4sAIgLafBLb5kjXEgYcYg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    hash = "sha256-cLBF3Teb2vcYUoE6Et6XgC5SAqV4MEpjTbpgb/TkMG0=";
=======
    hash = "sha256-LpknrrsIZ38NlQDMGpiA7cftspvCo/mQ8KAwKRkdVEc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

  disabledTests = [
    # fails to connect to local server
    "test_cache"
    "test_remote_stylesheet"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # pyo3_runtime.PanicException: event loop thread panicked
    "test_invalid_href"
  ];

<<<<<<< HEAD
  meta = {
    description = "Inline CSS into style attributes";
    homepage = "https://github.com/Stranger6667/css-inline";
    changelog = "https://github.com/Stranger6667/css-inline/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
  meta = with lib; {
    description = "Inline CSS into style attributes";
    homepage = "https://github.com/Stranger6667/css-inline";
    changelog = "https://github.com/Stranger6667/css-inline/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
