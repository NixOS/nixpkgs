{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  rarfile,
  unar,
}:

buildPythonPackage rec {
  pname = "reusables";
  version = "1.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "Reusables";
    tag = version;
    hash = "sha256-l8nARlyLPMLZnIdV5IT2HeZ8duUA94cc2jWEVrBJ5wc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    rarfile
    # rarfile has no built-in extractor and expects unrar/unar/bsdtar/7z on
    # PATH; unar is free and, unlike bsdtar, extracts the test fixture without
    # CRC errors
    unar
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # binds a local TCP socket, which the darwin sandbox denies
    "test_server_and_download"
  ];

  pythonImportsCheck = [ "reusables" ];

  meta = {
    description = "Commonly consumed code commodities for Python";
    homepage = "https://github.com/cdgriffith/Reusables";
    changelog = "https://github.com/cdgriffith/Reusables/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
}
