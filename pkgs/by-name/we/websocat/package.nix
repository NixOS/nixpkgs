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
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "vi";
    repo = "websocat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ukz7qM6yT6LCdUxew8KhwTeEuz3JF7LOsoHKGM9rBmQ=";
  };

  cargoHash = "sha256-taG+oi+9eh6CnhS7wKSxEzLXOtvVhtLT1D3EuS4AwWY=";

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

  nativeInstallCheckInputs = [ versionCheckHook ];

  # The wrapping is required so that the "sh-c" option of websocat works even
  # if sh is not in the PATH (as can happen, for instance, when websocat is
  # started as a systemd service).
  postInstall = ''
    wrapProgram $out/bin/websocat \
      --prefix PATH : ${lib.makeBinPath [ bash ]}
  '';

  doInstallCheck = true;

  meta = {
    description = "Command-line client for WebSockets (like netcat/socat)";
    homepage = "https://github.com/vi/websocat";
    changelog = "https://github.com/vi/websocat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      thoughtpolice
    ];
    mainProgram = "websocat";
  };
})
