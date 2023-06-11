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
  version = "0.9.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Stranger6667";
    repo = "css-inline";
    rev = "python-v${version}";
    hash = "sha256-JyciyXElGDvZgjfL0yz9KhCCDu9ZRZvOn8LwkmfYKSg=";
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
    hash = "sha256-9oLVMcrAB3JX9XSN5uBvrazFFG6J6s6V3HnEfz/qj2E=";
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
