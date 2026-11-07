{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  freetype,
  libGL,
  libx11,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "umlcraft";
  version = "0.17.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "udvlp";
    repo = "UmlCraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MUtyUV5uLHKS1b7Y9VeKZAe59u7RcIc+qIMOmAM4/2Q=";
  };

  cargoHash = "sha256-EWefJjcH1itdBsRM9/Rbz9p79R7KnGz2zj1OmrMbOs0=";

  cargoBuildFlags = [
    "-p"
    "umlcraft-app"
    "-p"
    "umlcraft-cli"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fontconfig
    freetype
    libx11
    libxcb
    libxkbcommon
    wayland
  ];

  # Some workspace tests need Astah's files, which the sandbox lacks.
  doCheck = false;

  postInstall = ''
    id=com.umlcraft.app
    install -Dm644 packaging/linux/$id.desktop $out/share/applications/$id.desktop
    install -Dm644 packaging/linux/$id.metainfo.xml $out/share/metainfo/$id.metainfo.xml
    install -Dm644 packaging/linux/$id.mime.xml $out/share/mime/packages/$id.xml
    install -Dm644 packaging/linux/$id.svg $out/share/icons/hicolor/scalable/apps/$id.svg
  '';

  # GPUI loads Vulkan, Wayland and OpenGL at run time.
  postFixup = ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
      ]
    } $out/bin/umlcraft
  '';

  # `umlcraft` opens a window; the CLI from the same workspace prints the version.
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/umlcraft-cli";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "UML modeling tool with support for Astah projects and structograms";
    homepage = "https://github.com/udvlp/UmlCraft";
    changelog = "https://github.com/udvlp/UmlCraft/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ samiuens ];
    mainProgram = "umlcraft";
    platforms = lib.platforms.linux;
  };
})
