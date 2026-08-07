{
  lib,
  buildDotnetModule,
  desktop-file-utils,
  dotnetCorePackages,
  fetchFromGitHub,
  makeDesktopItem,
  makeWrapper,
  avalonia,
  # Runtime dependencies
  libglvnd,
  # passthru
  nix-update-script,
}:
buildDotnetModule (finalAttrs: {
  pname = "wheelwizard";
  version = "2.4.11";

  src = fetchFromGitHub {
    owner = "TeamWheelWizard";
    repo = "WheelWizard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Dex2PDgwnxKguf0jtC1T0+jm7bA7jDfvspwkiqJgUg";
  };
  postPatch = ''
    rm .config/dotnet-tools.json
  '';

  projectFile = "WheelWizard";
  buildType = "Release";
  dotnet-sdk = dotnetCorePackages.sdk_8_0-bin;
  dotnet-runtime = dotnetCorePackages.runtime_8_0-bin;
  nugetDeps = ./deps.json;
  mapNuGetDependencies = true;

  nativeBuildInputs = [
    makeWrapper
    desktop-file-utils
  ];

  buildInputs = [
    avalonia
  ];

  runtimeDeps = [
    libglvnd
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/wheelwizard $out/bin
    cp -r WheelWizard/bin/Release/net8.0/*/* $out/lib/wheelwizard/

    makeWrapper $out/lib/wheelwizard/WheelWizard $out/bin/WheelWizard \
      --prefix PATH : ${lib.makeBinPath [ finalAttrs.dotnet-runtime ]}

    install -D $desktopItem/share/applications/* -t $out/share/applications

    runHook postInstall
  '';

  postFixup = ''
    rm $out/bin/*.{so,dylib}
  '';

  desktopItem = makeDesktopItem {
    name = "wheelwizard";
    exec = "WheelWizard";
    comment = "WheelWizard, Retro Rewind Launcher";
    desktopName = "Wheel Wizard";
    categories = [ "Game" ];
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "WheelWizard, Retro Rewind Launcher";
    homepage = "https://github.com/TeamWheelWizard/WheelWizard";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "WheelWizard";
    maintainers = with lib.maintainers; [ DerHalbGrieche ];
  };
})
