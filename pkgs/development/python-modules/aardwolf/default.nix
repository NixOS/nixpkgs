{ lib
, arc4
, asn1crypto
, asn1tools
, asyauth
, asysocks
, buildPythonPackage
, colorama
, fetchFromGitHub
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
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "aardwolf";
    rev = "86c4b511e0dfeeb767081902af2244f6297a68eb";
    hash = "sha256-ULczCJWVLrj0is6UYZxJNyLV6opzoJAFStqsjEmjaIA=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "source/aardwolf/utils/rlers";
    name = "${pname}-${version}";
    hash = "sha256-F6NLWc5B577iH0uKAdj2y2TtQfo4eeXkMIK6he1tpvQ=";
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
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "aardwolf"
  ];

  meta = with lib; {
    description = "Asynchronous RDP protocol implementation";
    homepage = "https://github.com/skelsec/aardwolf";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
