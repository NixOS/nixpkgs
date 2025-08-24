{
  lib,
  fetchurl,
  stdenv,
  wrapGAppsHook3,
  dpkg,
  autoPatchelfHook,
  glibc,
  gcc-unwrapped,
  nss,
  libdrm,
  libgbm,
  alsa-lib,
  xdg-utils,
  systemd,
}:
let
  baseUrl = "https://d2atcrkye2ik4e.cloudfront.net/download";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ticktick";
  version = "6.0.40";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "${baseUrl}/linux/linux_deb_x64/ticktick-${finalAttrs.version}-amd64.deb";
        hash = "sha256-0eBsD/qFCaK/Isu4XJVve+8TBssgLAsCCM1GHN23PIk=";
      }
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      fetchurl {
        url = "${baseUrl}/linux/linux_deb_arm64/ticktick-${finalAttrs.version}-arm64.deb";
        hash = "sha256-USKmydiyeY8Iibe+ebcGcmwo7XJEw/EEf/OY4PsSrl8=";
      }
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";

  nativeBuildInputs = [
    wrapGAppsHook3
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    nss
    glibc
    libdrm
    gcc-unwrapped
    libgbm
    alsa-lib
    xdg-utils
  ];

  # Needed to make the process get past zygote_linux fork()'ing
  runtimeDependencies = [ systemd ];

  unpackPhase = ''
    runHook preUnpack

    mkdir -p "$out/share" "$out/opt/ticktick" "$out/bin"
    dpkg-deb --fsys-tarfile "$src" | tar --extract --directory="$out"

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    cp -av $out/opt/TickTick/* $out/opt/ticktick
    cp -av $out/usr/share/* $out/share
    rm -rf $out/usr $out/opt/TickTick
    ln -sf "$out/opt/ticktick/ticktick" "$out/bin/ticktick"

    substituteInPlace "$out/share/applications/ticktick.desktop" \
      --replace "Exec=/opt/TickTick/ticktick" "Exec=$out/bin/ticktick"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Powerful to-do & task management app with seamless cloud synchronization across all your devices";
    homepage = "https://ticktick.com/home/";
    license = licenses.unfree;
    maintainers = with maintainers; [
      hbjydev
      jonocodes
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
