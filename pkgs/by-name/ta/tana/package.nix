{
  libX11,
  libxcb,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  stdenv,
  lib,
  alsa-lib,
  at-spi2-atk,
  atkmm,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libdrm,
  libglvnd,
  libxkbcommon,
  libgbm,
  nspr,
  nss,
  pango,
  systemd,
  fetchurl,
  autoPatchelfHook,
  dpkg,
}:
let
  glLibs = [
    libglvnd
    libgbm
  ];
  libs = [
    alsa-lib
    atkmm
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libX11
    libxcb
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libxkbcommon
    libXrandr
    nspr
    nss
    pango
  ];
  buildInputs = glLibs ++ libs;
  runpathPackages = glLibs ++ [
    stdenv.cc.cc
    stdenv.cc.libc
  ];
  version = "1.0.47";
in
stdenv.mkDerivation {
  pname = "tana";
  inherit version buildInputs;

  src = fetchurl {
    url = "https://github.com/tanainc/tana-desktop-releases/releases/download/v${version}/tana_${version}_amd64.deb";
    hash = "sha256-Si02dSMH7hnUNz3kxJavhfZLO46RAcanRvl8F/DrLY0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  appendRunpaths = map (pkg: "${lib.getLib pkg}/lib") runpathPackages ++ [
    "${placeholder "out"}/lib/tana"
  ];

  # Needed for Zygote
  runtimeDependencies = [
    systemd
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r usr/* $out
    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/tana.desktop \
      --replace "Exec=tana" "Exec=$out/bin/tana" \
      --replace "Name=tana" "Name=Tana"
  '';

  meta = with lib; {
    description = "Intelligent all-in-one workspace";
    longDescription = ''
      At its core, Tana is an outline editor which can be extended to
      cover multiple use-cases and different workflows.
      For individuals, it supports GTD, P.A.R.A., Zettelkasten note-taking
      out of the box. Teams can leverage the powerful project management
      views, like Kanban.
      To complete all, a powerful AI system is integrated to help with most
      of the tasks.
    '';
    homepage = "https://tana.inc";
    changelog = "https://tana.inc/releases";
    license = licenses.unfree;
    maintainers = [ maintainers.massimogengarelli ];
    platforms = platforms.linux;
    mainProgram = "tana";
  };
}
