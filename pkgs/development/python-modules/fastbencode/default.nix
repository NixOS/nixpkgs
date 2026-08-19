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
  version = "0.3.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "fastbencode";
    tag = "v${version}";
    hash = "sha256-hQwu0VKJ6tp155meE5JXbk5xEmcfktBHgUqVJYs2exM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-QHu3ryg7beYVBSWFxkX7CaJLcsrmGpGAm9Ee9ZHKTgk=";
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
