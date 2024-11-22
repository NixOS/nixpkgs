{
  lib,
  stdenv,
  fetchurl,
  swt,
  jre,
  makeWrapper,
  alsa-lib,
  jack2,
  fluidsynth,
  libpulseaudio,
  lilv,
  which,
  wrapGAppsHook3,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.6.4";
  pname = "tuxguitar";

  src = fetchurl {
    url = "https://github.com/helge17/tuxguitar/releases/download/${finalAttrs.version}/tuxguitar-${finalAttrs.version}-linux-swt-amd64.tar.gz";
    hash = "sha256-FD1+7jV69E9AfTczjD6DOGD+pPlscg4o8A9ADBUM9B4=";
  };

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r dist lib share $out/
    cp tuxguitar.sh $out/bin/tuxguitar

    ln -s $out/dist $out/bin/dist
    ln -s $out/lib $out/bin/lib
    ln -s $out/share $out/bin/share
  '';

  postFixup = ''
    wrapProgram $out/bin/tuxguitar \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${
        lib.makeBinPath [
          jre
          which
        ]
      } \
      --prefix LD_LIBRARY_PATH : "$out/lib/:${
        lib.makeLibraryPath [
          swt
          alsa-lib
          jack2
          fluidsynth
          libpulseaudio
          lilv
        ]
      }" \
      --prefix CLASSPATH : "${swt}/jars/swt.jar:$out/lib/tuxguitar.jar:$out/lib/itext.jar"
  '';

  passthru.tests = {
    nixos = nixosTests.tuxguitar;
  };

  meta = {
    description = "Multitrack guitar tablature editor";
    longDescription = ''
      TuxGuitar is a multitrack guitar tablature editor and player written
      in Java-SWT. It can open GuitarPro, PowerTab and TablEdit files.
    '';
    homepage = "https://github.com/helge17/tuxguitar";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ ardumont ];
    platforms = [ "x86_64-linux" ];
  };
})
