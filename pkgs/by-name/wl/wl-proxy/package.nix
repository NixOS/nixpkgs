{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  libdrm,
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
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wl-proxy";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = "wl-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jfZG4n4B76wuC/IJxSmzjv5CqmsFB+gPm7ucYZ9Tn4A=";
  };

  cargoHash = "sha256-O5WJBqjOs9pk06b/UdWWLOCmNEOZWviU+/tYXMIfWIM=";

  cargoBuildFlags = builtins.concatLists (
    lib.map (b: [
      "--bin"
      b
    ]) bins
  );

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

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Wayland connection proxy";
    homepage = "https://github.com/mahkoh/wl-proxy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ higherorderlogic ];
  };
})
