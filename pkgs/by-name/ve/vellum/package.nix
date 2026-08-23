{
  fetchFromGitHub,
  installShellFiles,
  lib,
  libGL,
  libxkbcommon,
  makeBinaryWrapper,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vellum";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "greyxp1";
    repo = "vellum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uWGaCeENwaqg2+wbtfgpDAjxIsJbgUcMnvSPauwjcBI=";
  };

  cargoHash = "sha256-quZW6jkGzvRHNgkJQS4entJyXeYftBOV89hKaFfQCDw=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
    wayland
  ];

  postInstall = ''
    manDir=$(find target -type d -path '*/build/vellum-*/out/man' -print -quit)
    installManPage "$manDir"/*.1

    wrapProgram $out/bin/vellum \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          vulkan-loader
          wayland
        ]
      }
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
    maintainers = with lib.maintainers; [ poz ];
    platforms = lib.platforms.linux;
    mainProgram = "vellum";
  };
})
