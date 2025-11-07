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
  version = "0.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "fastbencode";
    tag = "v${version}";
    hash = "sha256-fNvxeAKCHjtD9nl7Jhkzecu2CbTfOyPjdYedCPpqYgc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-e6TaJyHfrUHampTX42rPqdjQu7myj2+zahVJS+7SzIM=";
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

  meta = with lib; {
    description = "Fast implementation of bencode";
    homepage = "https://github.com/breezy-team/fastbencode";
    changelog = "https://github.com/breezy-team/fastbencode/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
