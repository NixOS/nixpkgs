{
  python3Packages,
  fetchPypi,
  lib,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ufbt";
  version = "0.2.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-TxqFiFhZjtLiW7q2ni6mBLwAdYw7Ho7PiXophmFXNjs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools-git-versioning<2" "setuptools-git-versioning"
  '';

  doCheck = false;

  build-system = with python3Packages; [
    setuptools
    setuptools-git-versioning
  ];

  dependencies = with python3Packages; [
    oslex
  ];

  meta = {
    description = "Compact tool for building and debugging applications for Flipper Zero.";
    homepage = "https://github.com/flipperdevices/flipperzero-ufbt";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ _0x2B ];
    mainProgram = "ufbt";
  };
})
