{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  #pytestCheckHook,
  pythonOlder,
  rustPlatform,
  #libiconv,
  darwin,
  rust-jemalloc-sys,
}:

buildPythonPackage rec {
  pname = "ruff";
  version = "0.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  outputs = [
    "out"
    "bin"
  ];

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    rev = "refs/tags/${version}";
    hash = "sha256-//ayB5ayYM5FqiSXDDns2tIL+PJ0Osvkp8+MEEL0L+8=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "lsp-types-0.95.1" = "sha256-8Oh299exWXVi6A39pALOISNfp8XBya8z+KT/Z7suRxQ=";
      "salsa-0.18.0" = "sha256-vuLgeaqIL8U+5PUHJaGdovHFapAMGGQ9nPAMJJnxz/o=";
    };
  };

  postPatch = ''
    sed -i -f ${./ruff_exe.sed} python/ruff/__main__.py
    sed -i 's#@RUFF_BIN@#${placeholder "bin"}/bin/ruff#' python/ruff/__main__.py
    cat python/ruff/__main__.py
  '';

  postInstall = ''
    mkdir -p $bin/bin
    mv $out/bin/ruff $bin/bin/
    rmdir $out/bin
  '';

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = [
    rust-jemalloc-sys
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.CoreServices ];

  pythonImportsCheck = [ "ruff" ];

  meta = {
    description = "Extremely fast Python linter";
    homepage = "https://github.com/astral-sh/ruff";
    changelog = "https://github.com/astral-sh/ruff/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "ruff";
    maintainers = with lib.maintainers; [
      figsoda
      GaetanLepage
    ];
  };
}
