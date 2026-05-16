{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  setuptools,
  setuptools-scm,

  cargo,
  rustc,
  setuptools-rust,

  numpy,

  pytestCheckHook,
  pytest-cov-stub,
  scikit-learn,
  scipy,
}:
buildPythonPackage (finalAttrs: {
  pname = "scalib";
  version = "0.6.4";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "simple-crypto";
    repo = "SCALib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DVXb93W0TmOcyGyMN5GmIJNAdbLeeFnNm+3QfTw2j5s=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-scm-git-archive",' ""
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-mzzp5EnaBYIbGGxJ9mJ6dqRVcTDS406BRx7hWVZ11SY=";
  };

  cargoRoot = "src/scalib_ext";

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    setuptools-rust
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    scikit-learn
    scipy
    numpy
  ];

  meta = {
    description = "Side-Channel Analysis Library";
    homepage = "https://github.com/simple-crypto/scalib";
    changelog = "https://github.com/simple-crypto/SCALib/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ d-brasher ];
  };
})
