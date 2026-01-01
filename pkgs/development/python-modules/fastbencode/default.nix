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
<<<<<<< HEAD
  version = "0.3.8";
=======
  version = "0.3.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "fastbencode";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vpo8OVhIm9/niMY6A878FRJ+zU98z9CJe/p5UxmvrLo=";
=======
    hash = "sha256-fNvxeAKCHjtD9nl7Jhkzecu2CbTfOyPjdYedCPpqYgc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-N4diwjHZkJk+Tzu609ueRipfIXyNhXhLG7hpnG1gRa4=";
=======
    hash = "sha256-e6TaJyHfrUHampTX42rPqdjQu7myj2+zahVJS+7SzIM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Fast implementation of bencode";
    homepage = "https://github.com/breezy-team/fastbencode";
    changelog = "https://github.com/breezy-team/fastbencode/releases/tag/v${version}";
    license = lib.licenses.gpl2Plus;
=======
  meta = with lib; {
    description = "Fast implementation of bencode";
    homepage = "https://github.com/breezy-team/fastbencode";
    changelog = "https://github.com/breezy-team/fastbencode/releases/tag/v${version}";
    license = licenses.gpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
