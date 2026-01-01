{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
<<<<<<< HEAD
=======
  electron,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  alsa-lib,
  gtk3,
  libxshmfence,
  libgbm,
<<<<<<< HEAD
  libGL,
  musl,
  nss,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thedesk";
  version = "25.2.2";

  src = fetchurl {
    url = "https://github.com/cutls/thedesk-next/releases/download/v${finalAttrs.version}/thedesk-next_${finalAttrs.version}_amd64.deb";
    hash = "sha256-9Xd0YHkFHPVY6BHy0V1X7p27m2iJFVHmSickzMJeOXs=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
=======
  nss,
}:

stdenv.mkDerivation rec {
  pname = "thedesk";
  version = "24.2.1";

  src = fetchurl {
    url = "https://github.com/cutls/TheDesk/releases/download/v${version}/${pname}_${version}_amd64.deb";
    sha256 = "sha256-AdjygNnQ3qQB03cGcQ5EB0cY3XXWLrzfCqw/U8tq1Yo=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    gtk3
<<<<<<< HEAD
    libgbm
    libGL
    libxshmfence
    musl
    nss
  ];

  runtimeDependencies = [ systemd ];
=======
    libxshmfence
    libgbm
    nss
  ];

  dontBuild = true;
  dontConfigure = true;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  installPhase = ''
    runHook preInstall

<<<<<<< HEAD
    substituteInPlace usr/share/applications/thedesk-next.desktop \
      --replace-fail "/opt/TheDesk/thedesk-next" "thedesk"
    cp --recursive usr $out
    mkdir $out/libexec $out/bin
    cp --recursive opt/TheDesk $out/libexec/thedesk
    ln --symbolic $out/libexec/thedesk/thedesk-next $out/bin/thedesk
=======
    mv usr $out
    mv opt $out

    # binary is not used and probably vulnerable to CVE(s)
    rm $out/opt/TheDesk/thedesk

    substituteInPlace $out/share/applications/thedesk.desktop \
      --replace '/opt/TheDesk' $out/bin

    makeWrapper ${electron}/bin/electron $out/bin/thedesk \
      --add-flags $out/opt/TheDesk/resources/app.asar
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    runHook postInstall
  '';

<<<<<<< HEAD
  preFixup = ''
    patchelf --add-needed libGL.so.1 $out/libexec/thedesk/thedesk-next
  '';

  meta = {
    description = "Mastodon/Misskey Client for PC";
    homepage = "https://thedesk.top";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl3Only;
=======
  meta = with lib; {
    description = "Mastodon/Misskey Client for PC";
    homepage = "https://thedesk.top";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "thedesk";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
