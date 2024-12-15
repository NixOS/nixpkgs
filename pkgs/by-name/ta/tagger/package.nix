{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  blueprint-compiler,
  chromaprint,
  glib,
  gtk4,
  libadwaita,
}:

let
  dotnet = dotnetCorePackages.dotnet_8;
in

buildDotnetModule rec {
  pname = "tagger";
  version = "2024.6.0-1";

  src = fetchFromGitHub {
    owner = "nlogozzo";
    repo = "NickvisionTagger";
    rev = version;
    hash = "sha256-4OfByQYhLXmeFWxzhqt8d7pLUyuMLhDM20E2YcA9Q3s=";
  };

  projectFile = "NickvisionTagger.GNOME/NickvisionTagger.GNOME.csproj";
  dotnet-sdk = dotnet.sdk;
  dotnet-runtime = dotnet.runtime;
  nugetDeps = ./deps.nix;

  nativeBuildInputs = [
    blueprint-compiler
  ];

  buildInputs = [
    chromaprint
    libadwaita
  ];

  runtimeDeps = [
    glib
    gtk4
    libadwaita
  ];

  executables = [ "NickvisionTagger.GNOME" ];

  postInstall = ''
    substituteInPlace NickvisionTagger.Shared/Linux/org.nickvision.tagger.desktop.in --replace '@EXEC@' "NickvisionTagger.GNOME"
    install -Dm444 NickvisionTagger.Shared/Resources/org.nickvision.tagger.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm444 NickvisionTagger.Shared/Resources/org.nickvision.tagger-symbolic.svg -t $out/share/icons/hicolor/symbolic/apps/
    install -Dm444 NickvisionTagger.Shared/Linux/org.nickvision.tagger.desktop.in -T $out/share/applications/org.nickvision.tagger.desktop
  '';

  meta = with lib; {
    description = "Easy-to-use music tag (metadata) editor";
    homepage = "https://github.com/NickvisionApps/Tagger";
    mainProgram = "NickvisionTagger.GNOME";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      zendo
      ratcornu
    ];
  };
}
