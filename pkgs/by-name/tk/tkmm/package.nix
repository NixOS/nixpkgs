{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  makeDesktopItem,
  copyDesktopItems,
  libGL,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildDotnetModule (finalAttrs: {
  pname = "tkmm";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "TKMM-Team";
    repo = "Tkmm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z9BfqSEa3smB70EKWw4Wsv8VlxFfr5BXd1UIHes4Uzk=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace src/Tkmm.Core/Helpers/DesktopEntryHelper.cs \
      --replace-fail 'return Environment.ProcessPath;' "return \"$out/bin/Tkmm\";"
  '';

  selfContainedBuild = true;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
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

  runtimeDeps = [ libGL ];

  enableParallelBuilding = false;
  dotnetFlags = [
    "-p:NoUpdate=true"
    "-p:UseApplicationDataFolder=true"
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

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/Tkmm.CLI";
  versionCheckKeepEnvironment = [
    "HOME"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "CFFIXED_USER_HOME" ];

  preVersionCheck =
    if stdenv.hostPlatform.isDarwin then
      ''
        export CFFIXED_USER_HOME="$HOME"
        mkdir -p "$HOME/Library/Application Support"
      ''
    else
      ''
        mkdir -p "$HOME/.config"
      '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mod merger and manager for Tears of the Kingdom";
    homepage = "https://tkmm.org/";
    license = lib.licenses.mit;
    mainProgram = "Tkmm";
    maintainers = with lib.maintainers; [
      rucadi
    ];
    platforms = lib.platforms.unix;
  };
})
