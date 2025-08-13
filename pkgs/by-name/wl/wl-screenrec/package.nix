{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  libdrm,
  ffmpeg_6,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wl-screenrec";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "russelltg";
    repo = "wl-screenrec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O3DNiLiZ1Rh5vesJX+cLv6cVcOVVUfWX914034R3ASQ=";
  };

  cargoHash = "sha256-shby6XE8xg5gqBoWlQn/Q0E+AmbyC8hFRp+EaBYS3Fs=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildInputs = [
    wayland
    libdrm
    ffmpeg_6
  ];

  doCheck = false; # tests use host compositor, etc

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd wl-screenrec \
      --bash <($out/bin/wl-screenrec --generate-completions bash) \
      --fish <($out/bin/wl-screenrec --generate-completions fish) \
      --zsh <($out/bin/wl-screenrec --generate-completions zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High performance wlroots screen recording, featuring hardware encoding";
    homepage = "https://github.com/russelltg/wl-screenrec";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "wl-screenrec";
    maintainers = with lib.maintainers; [ colemickens ];
  };
})
