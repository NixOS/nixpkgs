{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustc,
  rustPlatform,
  setuptools,
  setuptools-rust,
  python,
}:

buildPythonPackage rec {
  pname = "fastbencode";
  version = "0.3.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "fastbencode";
    tag = "v${version}";
    hash = "sha256-e+Ei+UIJ5sve6k3ApPJ2nswTgZLkzxZmpthK/f/rfCs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-dqD/QF6/XCB9H/QkEobfIOo9S663fh9AHUuHqCoEcLM=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  build-system = [
    setuptools
    setuptools-rust
  ];

  pythonImportsCheck = [ "fastbencode" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest tests.test_suite
    runHook postCheck
  '';

  meta = {
    description = "Fast implementation of bencode";
    homepage = "https://github.com/breezy-team/fastbencode";
    changelog = "https://github.com/breezy-team/fastbencode/releases/tag/v${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
}
