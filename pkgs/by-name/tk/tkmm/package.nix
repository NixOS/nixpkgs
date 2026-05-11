{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  makeDesktopItem,
  copyDesktopItems,
  libx11,
  glew,
  libGL,
  libice,
  libsm,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
}:
buildDotnetModule (finalAttrs: {
  pname = "Tkmm";
  version = "2.0.0-beta3";

  src = fetchFromGitHub {
    owner = "TKMM-Team";
    repo = "Tkmm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XdnNKnusvWhNy/0rQCULft6ztsB/nhTeQiN4F9LmxJE=";
    fetchSubmodules = true;
  };

  patches = [ ./patchTk.diff ];

  selfContainedBuild = true;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;
  projectFile = [
    "src/Tkmm/Tkmm.csproj"
    "src/Tkmm.CLI/Tkmm.CLI.csproj"
  ];
  nugetDeps = ./deps.json;
  executables = [
    "Tkmm"
    "Tkmm.CLI"
  ];

  nativeBuildInputs = [ copyDesktopItems ];

  runtimeDeps = [
    # Avalonia UI
    libx11
    libGL
    glew
    libice
    libsm
    libxcursor
    libxext
    libxi
    libxrandr
  ];

  enableParallelBuilding = false;
  dotnetFlags = [
    ''-p:DefineConstants="READONLY_FS"''
  ];

  postInstall = ''
    install -D distribution/appimage/tkmm.svg $out/share/icons/hicolor/scalable/apps/tkmm.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Tears of the Kingdom Mod Manager";
      exec = "Tkmm";
      icon = "tkmm";
      desktopName = "TKMM";
      categories = [
        "Game"
      ];
      comment = "Tears of the Kingdom Mod Manager";
    })
  ];

  meta = {
    description = "Tears of the Kingdom Mod Manager, a mod merger and manager for TotK";
    homepage = "https://tkmm.org/";
    license = lib.licenses.mit;
    mainProgram = "Tkmm";
    maintainers = with lib.maintainers; [
      rucadi
    ];
    platforms = lib.platforms.unix;
  };
})
