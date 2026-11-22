{
  fetchFromGitHub,
  fontconfig,
  installShellFiles,
  lib,
  libxkbcommon,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vellum";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "greyxp1";
    repo = "vellum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S+0z8epsGS9nFVH3vzoZ50fjdnxo4Mb2zgBJ6ryNgdU=";
  };

  cargoHash = "sha256-7v4bFe4Kuxph1BxG7tZxps/K6QzreZRLmwWATtgUmx0=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    fontconfig
    libxkbcommon
    wayland
  ];

  postInstall = ''
    outputDir=$(find target -type d -path '*/build/vellum-*/out' -print -quit | head -n 1)

    installManPage "$outputDir"/man/*.1
    installShellCompletion "$outputDir"/completions/vellum.{bash,fish,nu} \
      --zsh "$outputDir"/completions/_vellum

    install -Dm644 "$outputDir"/completions/vellum.elv \
      $out/share/elvish/lib/vellum.elv
    install -Dm644 "$outputDir"/completions/_vellum.ps1 \
      $out/share/powershell/vellum.Completion.ps1
  '';

  postFixup = ''
    # wgpu loads Vulkan dynamically, so its path must be added after RPATH shrinking.
    patchelf --add-rpath "${lib.makeLibraryPath [ vulkan-loader ]}" "$out/bin/vellum"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Live screen annotation overlay for Wayland";
    homepage = "https://github.com/greyxp1/vellum";
    changelog = "https://github.com/greyxp1/vellum/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/greyxp1/vellum/releases";
    license =
      with lib.licenses;
      AND [
        isc
        mit
      ];
    maintainers = with lib.maintainers; [
      greyxp1
      poz
    ];
    platforms = lib.platforms.linux;
    mainProgram = "vellum";
  };
})
