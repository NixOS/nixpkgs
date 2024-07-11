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
  minikerberos,
  pillow,
  pyperclip,
  pythonOlder,
  rustPlatform,
  rustc,
  setuptools-rust,
  tqdm,
  unicrypto,
  winsspi,
}:

buildPythonPackage rec {
  pname = "aardwolf";
  version = "0.2.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "aardwolf";
    rev = "refs/tags/${version}";
    hash = "sha256-4kJsW0uwWfcgVruEdDw3QhbzfPDuLjmK+YvcLrgF4SI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/aardwolf/utils/rlers";
    name = "${pname}-${version}";
    hash = "sha256-i7fmdWOseRQGdvdBnlGi+lgWvhC2WFI2FwXU9JywYsc=";
  };

  cargoRoot = "aardwolf/utils/rlers";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    setuptools-rust
    cargo
    rustc
  ];

  propagatedBuildInputs = [
    arc4
    asn1crypto
    asn1tools
    asyauth
    asysocks
    colorama
    minikerberos
    pillow
    pyperclip
    tqdm
    unicrypto
    winsspi
  ] ++ lib.optionals (stdenv.isDarwin) [ iconv ];

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
