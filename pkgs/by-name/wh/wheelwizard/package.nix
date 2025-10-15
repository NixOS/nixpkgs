{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  makeWrapper,
  makeDesktopItem,
  desktop-file-utils,
}:
buildDotnetModule rec {
  pname = "wheelwizard";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "TeamWheelWizard";
    repo = "WheelWizard";
    tag = "${version}";
    hash = "sha256-DuEI6bmvNP6wRuZX9Do0FGDsu80ldy0SCefBk6gqT9s=";
  };
  postPatch = ''
    rm .config/dotnet-tools.json
  '';

  projectFile = "WheelWizard.sln";
  buildType = "Release";
  dotnet-sdk = dotnetCorePackages.sdk_8_0-bin;
  dotnet-runtime = dotnetCorePackages.runtime_8_0-bin;
  dotnet-tools = [];
  nugetDeps = ./deps.json;

  nativeBuildInputs = [
    makeWrapper
    desktop-file-utils
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/${pname}

    cp -r WheelWizard/bin/Release/net8.0/* $out/lib/${pname}/

    mkdir -p $out/bin

    makeWrapper $out/lib/${pname}/WheelWizard $out/bin/WheelWizard \
      --prefix PATH : ${lib.makeBinPath [dotnet-runtime]}

    install -D $desktopItem/share/applications/* -t $out/share/applications

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = "wheelwizard";
    exec = "WheelWizard";
    comment = "WheelWizard, Retro Rewind Launcher";
    desktopName = "Wheel Wizard";
    categories = ["Utility"];
  };

  meta = with lib; {
    description = "WheelWizard, Retro Rewind Launcher";
    homepage = "https://github.com/TeamWheelWizard/WheelWizard";
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "bin/WheelWizard";
  };
}
