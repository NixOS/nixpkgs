{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools-rust
, rustPlatform
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rtoml";
  version = "0.7";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-h4vY63pDkrMHt2X244FssLxHsphsfjNd6gnVFUeZZTY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "05fwcs6w023ihw3gyihzbnfwjaqy40d6h0z2yas4kqkkvz9x4f8j";
  };

  nativeBuildInputs = with rustPlatform; [
    setuptools-rust
    rust.rustc
    rust.cargo
    cargoSetupHook
  ];

  pythonImportsCheck = [ "rtoml" ];

  checkInputs = [ pytestCheckHook ];
  preCheck = ''
    cd tests
  '';

  meta = with lib; {
    description = "Rust based TOML library for python";
    homepage = "https://github.com/samuelcolvin/rtoml";
    license = licenses.mit;
    maintainers = with maintainers; [ evils ];
  };
}
