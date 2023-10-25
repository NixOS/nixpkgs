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
  version = "0.10.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Stranger6667";
    repo = "css-inline";
    rev = "python-v${version}";
    hash = "sha256-oBAJv/hAz/itT2WakIw/1X1NvOHX108NoeS6V7k+aG8=";
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
    hash = "sha256-SFG1nsP4+I0zH8VeyL1eeaTx0tHNIvmx6M0cko0pqIA=";
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
