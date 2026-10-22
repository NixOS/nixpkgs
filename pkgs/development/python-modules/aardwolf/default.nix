{
  lib,
  stdenv,
  arc4,
  asn1crypto,
  asn1tools,
  asyauth,
  asysocks,
  buildPythonPackage,
  cargo,
  colorama,
  fetchFromGitHub,
  iconv,
  pillow,
  pyperclip,
  rustPlatform,
  rustc,
  setuptools,
  setuptools-rust,
  tqdm,
  unicrypto,
}:

buildPythonPackage rec {
  pname = "aardwolf";
  version = "0.2.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "aardwolf";
    tag = version;
    hash = "sha256-8QXPvfVeT3qadxTvt/LQX3XM5tGj6SpfOhP/9xcZHW4=";
  };

  patches = [ ./update-pyo3.patch ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      patches
      ;
    sourceRoot = "${src.name}/aardwolf/utils/rlers";
    hash = "sha256-n28jzS2+zbXsdR7rT0PBvcqNacuFMJKUug0mBYc4eFE=";
    patchFlags = [ "-p4" ]; # strip i/aardwolf/utils/rlers/ prefix
  };

  cargoRoot = "aardwolf/utils/rlers";

  build-system = [
    setuptools
    setuptools-rust
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  dependencies = [
    arc4
    asn1crypto
    asn1tools
    asyauth
    asysocks
    colorama
    pillow
    pyperclip
    tqdm
    unicrypto
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [ iconv ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "aardwolf" ];

  meta = {
    description = "Asynchronous RDP protocol implementation";
    mainProgram = "ardpscan";
    homepage = "https://github.com/skelsec/aardwolf";
    changelog = "https://github.com/skelsec/aardwolf/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
