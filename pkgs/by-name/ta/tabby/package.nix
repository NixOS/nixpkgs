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
  version = "0.6.0";
  pname = "tabby";

  src = fetchFromGitHub {
    owner = "TabbyML";
    repo = "tabby";
    rev = "v${version}";
    hash = "sha256-cZvfJMFsf7m8o5YKpsJpcrRmxJCQOFxrDzJZXMzVeFA=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-iv8MpBfGGUFkjUZ9eAGq65vCy62VJQGTYIS0r9GRyfo=";

  # https://github.com/TabbyML/tabby/blob/v0.6.0/Dockerfile#L40C5-L40C58
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
