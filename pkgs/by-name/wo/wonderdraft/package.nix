{
  lib,
  stdenv,
  requireFile,
  dpkg,
  xorg,
  libGL,
  alsa-lib,
  pulseaudio,
}:

stdenv.mkDerivation rec {
  pname = "wonderdraft";
  version = "1.1.8.2b";

  src = requireFile {
    name = "Wonderdraft-${version}-Linux64.deb";
    url = "https://wonderdraft.net/";
    hash = "sha256-3eYnEH6P94z9axFsrkJA4QMcHyg/gNRczqL3h5Sc2Tg=";
  };

  nativeBuildInputs = [
    dpkg
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -R usr/share opt $out/
    substituteInPlace \
      $out/share/applications/Wonderdraft.desktop \
      --replace /opt/ $out/opt/
    ln -s $out/opt/Wonderdraft/Wonderdraft.x86_64 $out/bin/Wonderdraft.x86_64
    runHook postInstall
  '';
  preFixup =
    let
      libPath = lib.makeLibraryPath [
        xorg.libXcursor
        xorg.libXinerama
        xorg.libXrandr
        xorg.libX11
        xorg.libXi
        libGL
        alsa-lib
        pulseaudio
      ];
    in
    ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/opt/Wonderdraft/Wonderdraft.x86_64
    '';

  meta = with lib; {
    homepage = "https://wonderdraft.net/";
    description = "Mapmaking tool for Tabletop Roleplaying Games, designed for city, region, or world scale";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jsusk ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
