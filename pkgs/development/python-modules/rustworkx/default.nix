{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  cargo,
  rustPlatform,
  rustc,
  setuptools,
  setuptools-rust,
  numpy,
  fixtures,
  networkx,
  testtools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rustworkx";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "rustworkx";
    rev = version;
    hash = "sha256-hzB99ReL1bTmj1mYne9rJp2rBeMnmIR17VQFVl7rzr0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-9NMTGq8KzIvnOXrsUpFHrtM9K/E7RMrE/Aa9mtO7pTI=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  build-system = [
    setuptools
    setuptools-rust
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    fixtures
    networkx
    pytestCheckHook
    testtools
  ];

  preCheck = ''
    rm -r rustworkx
  '';

  pythonImportsCheck = [ "rustworkx" ];

  meta = with lib; {
    description = "High performance Python graph library implemented in Rust";
    homepage = "https://github.com/Qiskit/rustworkx";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
