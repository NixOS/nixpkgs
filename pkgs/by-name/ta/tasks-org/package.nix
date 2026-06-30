{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  zlib,
  libgcc,
  libGL,
  fontconfig,
  freetype,
  wayland,
  alsa-lib,
  libx11,
  libxext,
  libxrender,
  libxtst,
  libxi,
}:

stdenv.mkDerivation rec {
  pname = "tasks-org";
  version = "15.7.1";

  src = fetchurl {
    url = "https://github.com/tasks/tasks/releases/download/${version}/tasks-org-${version}-linux-amd64.tar.gz";
    hash = "sha256-L7WC7o2dTYG31ZKyVRcKwWFg4shhK4SZDCE7nGByGDc=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    zlib
    libgcc
    stdenv.cc.cc.lib
    libGL
    fontconfig
    freetype
    wayland
    alsa-lib
    libx11
    libxext
    libxrender
    libxtst
    libxi
  ];

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share

    cp -r tasks-org-${version}/bin/tasks-org $out/bin/
    cp -r tasks-org-${version}/lib/* $out/lib/
    cp -r tasks-org-${version}/share/* $out/share/

    # Fix hardcoded path in desktop entry
    substituteInPlace $out/share/applications/org.tasks.desktop \
      --replace-fail "/usr/lib/tasksorg-llc/tasks-org/bin/tasks-org" "$out/bin/tasks-org"

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/tasks-org \
      --prefix LD_LIBRARY_PATH : "$out/lib/runtime/lib:$out/lib/runtime/lib/server"
  '';

  meta = {
    description = "Tasks.org - Astrid Tasks successor, task management app";
    homepage = "https://tasks.org";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "tasks-org";
  };
}
