{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  libdrm,
  sqlite,
}:
let
  bins = [
    "log-dmabuf-feedback"
    "window-to-tray"
    "wl-cm-filter"
    "wl-format-filter"
    "wl-paper"
    "wl-veil"
  ];
  cargoFlags = lib.concatMap (b: [
    "--bin"
    b
  ]) bins;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wl-proxy";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = "wl-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WcJDOXpBPU8EIPMca96Yl9CUmMh7juRfkEjftVpQdRo=";
  };

  cargoHash = "sha256-nGzobdVDz+bhev1PrvopMIDTdHuHu1RAVegc/xglnGU=";

  cargoBuildFlags = cargoFlags;

  buildInputs = [ libdrm ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) (
    lib.concatMapStringsSep "\n" (b: ''
      installShellCompletion --cmd ${b} \
        --bash <($out/bin/${b} --generate-completion bash) \
        --zsh <($out/bin/${b} --generate-completion zsh) \
        --fish <($out/bin/${b} --generate-completion fish)
    '') bins
  );

  cargoCheckFlags = cargoFlags;

  checkInputs = [ sqlite ];

  preCheck = ''
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Wayland connection proxy";
    homepage = "https://github.com/mahkoh/wl-proxy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ higherorderlogic ];
    platforms = lib.platforms.linux;
  };
})
