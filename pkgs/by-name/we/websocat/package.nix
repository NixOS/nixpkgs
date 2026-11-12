{
  lib,
  stdenv,
  bash,
  fetchFromGitHub,
  libiconv,
  makeWrapper,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "websocat";
  version = "1.14.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vi";
    repo = "websocat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dPlnY63oKG+ZJsgkWM+OQTl+rqQaM0gKVEDbR6YKRAY=";
  };

  cargoHash = "sha256-qfMheEKUrNFhbY360u1gRz4UZVvT1Ad6uL+UQDiuwhs=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  # The wrapping is required so that the "sh-c" option of websocat works even
  # if sh is not in the PATH (as can happen, for instance, when websocat is
  # started as a systemd service).
  postInstall = ''
    wrapProgram $out/bin/websocat \
      --prefix PATH : ${lib.makeBinPath [ bash ]}
  '';

  # Darwin requires local networking for the checks
  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Command-line client for WebSockets (like netcat/socat)";
    homepage = "https://github.com/vi/websocat";
    changelog = "https://github.com/vi/websocat/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      thoughtpolice
      kybe236
    ];
    mainProgram = "websocat";
  };
})
