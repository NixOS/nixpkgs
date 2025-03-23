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
  pythonOlder,
  rustPlatform,
  rustc,
  setuptools,
  setuptools-rust,
  tqdm,
  unicrypto,
}:

buildPythonPackage rec {
  pname = "aardwolf";
  version = "0.2.11";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "aardwolf";
    rev = "0586591e948977ca5945252c893ba8f766ff8d28";
    hash = "sha256-daDxkQ7N0+yS2JOLfXJq4jv+5VQNnwtqIMy2p8j+Sag=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    sourceRoot = "${src.name}/aardwolf/utils/rlers";
    name = "${pname}-${version}";
    hash = "sha256-doBraJQtekrO/ZZV9KFz7BdIgBVVWtQztUS2Gz8dDdA=";
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
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin) [ iconv ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "aardwolf" ];

  meta = with lib; {
    description = "Asynchronous RDP protocol implementation";
    mainProgram = "ardpscan";
    homepage = "https://github.com/skelsec/aardwolf";
    changelog = "https://github.com/skelsec/aardwolf/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
