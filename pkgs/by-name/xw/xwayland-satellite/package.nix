{
  lib,
  fetchFromGitHub,
  installShellFiles,
  libxcb,
  makeBinaryWrapper,
  nix-update-script,
  pkg-config,
  rustPlatform,
  libxcb-cursor,
  xwayland,
  fetchpatch2,
  withSystemd ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xwayland-satellite";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mb7jpqnrcYCfNSItIkkHpuR3YxWFxPuIBfcwNKlRBkk=";
  };

  patches = [
    # fix steam dropdowns closing instantly and unity add component not focusing
    # https://github.com/Supreeeme/xwayland-satellite/pull/494
    (fetchpatch2 {
      name = "fix-dropdowns-closing-instantly";
      url = "https://github.com/Supreeeme/xwayland-satellite/commit/add2795134593faafce60e404a0a75df68e9ee0c.diff?full_index=1";
      hash = "sha256-6QOZsE4/OoYjzNlzkzMmx6d9rcuh66AHjTBUqHnAWxU=";
    })
  ];

  postPatch = ''
    substituteInPlace resources/xwayland-satellite.service \
      --replace-fail '/usr/local/bin' "$out/bin"
  '';

  cargoHash = "sha256-Saa3SRsQuY6u6pfBGezaEExOt/ReblnrG7pAXjA6Dk8=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libxcb
    libxcb-cursor
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional withSystemd "systemd";

  outputs = [
    "out"
    "man"
  ];

  # All integration tests require a running display server
  doCheck = false;

  postInstall = ''
    installManPage --name xwayland-satellite.1 xwayland-satellite.man
  ''
  + lib.optionalString withSystemd ''
    install -Dm0644 resources/xwayland-satellite.service -t $out/lib/systemd/user
  '';

  postFixup = ''
    wrapProgram $out/bin/xwayland-satellite \
      --prefix PATH : "${lib.makeBinPath [ xwayland ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Xwayland outside your Wayland compositor";
    longDescription = ''
      Grants rootless Xwayland integration to any Wayland compositor implementing xdg_wm_base.
    '';
    homepage = "https://github.com/Supreeeme/xwayland-satellite";
    changelog = "https://github.com/Supreeeme/xwayland-satellite/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      if-loop69420
      sodiboo
      getchoo
    ];
    mainProgram = "xwayland-satellite";
    platforms = lib.platforms.linux;
  };
})
