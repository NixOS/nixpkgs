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
  version = "0.2.12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "aardwolf";
    tag = version;
    hash = "sha256-CMO3qhxYmwB9kWIiHWV/0gAfs/yCnHzpfNYLTy4wX78=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    sourceRoot = "${src.name}/aardwolf/utils/rlers";
    name = "${pname}-${version}";
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
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin) [ iconv ];

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
