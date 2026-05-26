{
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
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
  pipewire,
  replaceVars,
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
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    nspr
    nss
    pango
  ];
  buildInputs = glLibs ++ libs;
  runpathPackages = glLibs ++ [
    stdenv.cc.cc
    stdenv.cc.libc
  ];
  version = "1.515.0";
in
stdenv.mkDerivation {
  pname = "tana";
  inherit version buildInputs;

  src = fetchurl {
    url = "https://github.com/tanainc/tana-desktop-releases/releases/download/v${version}/tana_${version}_amd64.deb";
    hash = "sha256-L6opOfwlcgADWbMibPtF4YijsFWroYL7alpvDHN5rtg=";
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

  patches = [
    (replaceVars ./pipewire-system-audio.patch {
      pipewire = lib.getBin pipewire;
    })
  ];

  postPatch = ''
    main="usr/lib/tana/resources/app/build/main.js"

    unsupportedBranch='else Ox=()=>(console.warn("System audio capture not supported on this platform"),"denied"),Dx=async()=>(console.warn("System audio capture not supported on this platform"),"denied"),Nx=async()=>{throw console.warn("System audio capture not supported on this platform"),new Error("System audio capture not supported on this platform")};var HM=require("electron")'
    pipewireBranch='else { let systemAudio = require("./nix-pipewire-system-audio.js"); Ox = systemAudio.getSystemAudioPermission; Dx = systemAudio.requestSystemAudioPermission; Nx = systemAudio.recordSystemAudio; } var HM=require("electron")'

    # Tana ships minified Electron code. Keep these checks strict so version
    # bumps fail loudly if upstream changes the audio capture implementation.
    grep -Fq -- "$unsupportedBranch" "$main" || {
      echo "Tana system-audio patch target not found" >&2
      exit 1
    }

    substituteInPlace "$main" \
      --replace-fail "$unsupportedBranch" "$pipewireBranch"

    loopbackCount="$(grep -oF 'audio:"loopback"' "$main" | wc -l | tr -d ' ')"
    if [ "$loopbackCount" -ne 2 ]; then
      echo "Expected 2 Tana loopback targets, found $loopbackCount" >&2
      exit 1
    fi

    substituteInPlace "$main" \
      --replace-fail 'audio:"loopback"' 'audio:n.frame'
  '';

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

  meta = {
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
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.massimogengarelli ];
    platforms = lib.platforms.linux;
    mainProgram = "tana";
  };
}
