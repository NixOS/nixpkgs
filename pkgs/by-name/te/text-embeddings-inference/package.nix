{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  protobuf,
  cmake,
  onnxruntime,
}:

rustPlatform.buildRustPackage rec {
  pname = "text-embeddings-inference";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "text-embeddings-inference";
    rev = "v${version}";
    hash = "sha256-Z6dNThzIHCKbiuyGTbvhZ9Wc2cbsxEp4nRTAOUqbuow=";
  };

  cargoHash = "sha256-9DOPHt6SoCTJpKRujDBr8vBvFT+YHA3hHFsLW2EOcxc=";

  nativeBuildInputs = [
    pkg-config
    cmake
    protobuf
  ];

  buildInputs = [
    openssl
    onnxruntime
  ];

  PROTOC = "${protobuf}/bin/protoc";
  ORT_LIB_LOCATION = "${onnxruntime}/lib";
  ORT_SKIP_DOWNLOAD = "1";

  cargoBuildFlags = [
    "--features"
    "candle"
  ];

  #
  doCheck = false;

  meta = with lib; {
    description = "A blazing fast inference solution for text embeddings models";
    homepage = "https://github.com/huggingface/text-embeddings-inference";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
