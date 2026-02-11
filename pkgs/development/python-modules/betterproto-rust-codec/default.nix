{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  cargo,
  rustc,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "betterproto-rust-codec";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "124C41p";
    repo = "betterproto-rust-codec";
    tag = "v${version}";
    hash = "sha256-Q8oCk/VVe4Dcw6Z5PBFJBKRlsHgi6Jn+FWDqLH8BgYc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-zYXE55o1/Tt6XJahV6WcGANPM/9xk6uYwQLazkIJj7A=";
  };

  build-system = [
    rustPlatform.maturinBuildHook
  ];

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  pythonImportsCheck = [
    "betterproto_rust_codec"
  ];

  meta = {
    description = "Converter between betterproto messages and the Protobuf wire format";
    homepage = "https://github.com/124C41p/betterproto-rust-codec/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
