{ lib
, stdenv
, arc4
, asn1crypto
, asn1tools
, asyauth
, asysocks
, buildPythonPackage
, colorama
, fetchFromGitHub
, iconv
, minikerberos
, pillow
, pyperclip
, pythonOlder
, rustPlatform
, setuptools-rust
, tqdm
, unicrypto
, winsspi
}:

buildPythonPackage rec {
  pname = "aardwolf";
  version = "0.2.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "aardwolf";
    rev = "refs/tags/${version}";
    hash = "sha256-xz3461QgZ2tySj2cTlKQ5faYQDSECvbk1U6QCbzM86w=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "source/aardwolf/utils/rlers";
    name = "${pname}-${version}";
    hash = "sha256-JGXTCCyC20EuUX0pP3xSZG3qFB5jRL7+wW2YRC3EiCc=";
  };

  cargoRoot = "aardwolf/utils/rlers";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    setuptools-rust
  ] ++ (with rustPlatform.rust; [
    cargo
    rustc
  ]);

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
  ] ++ lib.optionals (stdenv.isDarwin) [
    iconv
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "aardwolf"
  ];

  meta = with lib; {
    description = "Asynchronous RDP protocol implementation";
    homepage = "https://github.com/skelsec/aardwolf";
    changelog = "https://github.com/skelsec/aardwolf/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
