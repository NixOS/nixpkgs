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

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    sourceRoot = "${src.name}/aardwolf/utils/rlers";
    hash = "sha256-+2hENnrG35eRgQwtCCJUux9mYEkzD2astLgOqWHrH/M=";
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

  meta = with lib; {
    description = "Asynchronous RDP protocol implementation";
    mainProgram = "ardpscan";
    homepage = "https://github.com/skelsec/aardwolf";
    changelog = "https://github.com/skelsec/aardwolf/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
