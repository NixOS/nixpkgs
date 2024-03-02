{ lib
, fetchFromGitHub
, gcc12
, cmake
, git
, openssl
, pkg-config
, protobuf
, rustPlatform
, addOpenGLRunpath
, cudatoolkit
, nvidia ? true
}:

rustPlatform.buildRustPackage rec {
  version = "0.7.0";
  pname = "tabby";

  src = fetchFromGitHub {
    owner = "TabbyML";
    repo = "tabby";
    rev = "v${version}";
    hash = "sha256-BTPJWvqO4IuQAiUEER9PYfu4aQsz5RI77WsA/gQu5Jc=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-Du0ya9J+0tz72mSid5If0VFX2lLC7YtwNQ/MALpFv2M=";

  # https://github.com/TabbyML/tabby/blob/v0.7.0/.github/workflows/release.yml#L39
  cargoBuildFlags = [
    "--release"
    "--package" "tabby"
  ] ++ lib.optional nvidia [
    "--features" "cuda"
  ];

  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    protobuf
    git
    cmake
    gcc12

  ] ++ lib.optional nvidia [
    addOpenGLRunpath
  ];

  buildInputs = [ openssl ]
    ++ lib.optional nvidia cudatoolkit
  ;

  postInstall = ''
    ${if nvidia then ''
    addOpenGLRunpath "$out/bin/tabby"
    '' else ''
    ''}
  '';

  # Fails with:
  # file cannot create directory: /var/empty/local/lib64/cmake/Llama
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/TabbyML/tabby";
    changelog = "https://github.com/TabbyML/tabby/releases/tag/v${version}";
    description = "Self-hosted AI coding assistant";
    mainProgram = "tabby";
    license = licenses.asl20;
    maintainers = [ maintainers.ghthor ];
  };
}
