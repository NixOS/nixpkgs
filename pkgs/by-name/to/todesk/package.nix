{ stdenv
, lib
, fetchurl
, dpkg
, coreutils-full
, autoPatchelfHook
, makeWrapper
, gzip
, gnutar
, nspr
, kmod
, systemdMinimal
, glib
, bubblewrap
, libX11
, libXrandr
, glibc
, libdrm
, coreutils
, libGL
, bash
, libXcomposite
, libXdamage
, libXfixes
, libXtst
, nss
, libXxf86vm
, gtk3
, gdk-pixbuf
, pango
, appindicator-sharp
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "todesk";
  version = "4.7.2.0";

  src = fetchurl {
    url = "https://newdl.todesk.com/linux/todesk-v${finalAttrs.version}-amd64.deb";
    sha256 = "sha256-v7VpXXFVaKI99RpzUWfAc6eE7NHGJeFrNeUTbVuX+yg=";
    curlOptsList = [ "--user-agent" "Mozilla/5.0" ];
  };

  nativeBuildInputs = [ dpkg autoPatchelfHook ];
  buildInputs = [
    nspr
    kmod
    systemdMinimal
    glib
    bash
    coreutils
    libX11
    libXrandr
    glibc
    libdrm
    libGL
    libXcomposite
    libXdamage
    libXfixes
    libXtst
    nss
    libXxf86vm
    gtk3
    gdk-pixbuf
    pango
    appindicator-sharp
  ];

  autoPatchelfIgnoreMissingDeps = [ "iHD_drv_video.so" "libglut.so" "libigdgmm.so" "libmfx.so" "libmfxhw64.so" "libva.so" "libva-drm.so" "libva-x11.so" "libzrtc.so" ];

  unpackPhase = ''
    runHook preUnpack
    dpkg -x $src ./todesk-src
    runHook postUnpack
  '';

  installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp -r todesk-src/* "$out"
        echo "#! ${bash}/bin/bash -e" > "$out/opt/todesk/bin/ToDesk-Wrap"
        echo "if [ ! -d /var/lib/todesk ]; then">> "$out/opt/todesk/bin/ToDesk-Wrap"
        echo "mkdir /var/lib/todesk" >> "$out/opt/todesk/bin/ToDesk-Wrap"
        echo "fi">> "$out/opt/todesk/bin/ToDesk-Wrap"
        echo "${bubblewrap}/bin/bwrap --dev /dev --ro-bind /nix/store /nix/store --bind $out/opt/todesk/bin /opt/todesk/bin --ro-bind $out/opt/todesk/res /opt/todesk/res --bind /var/lib/todesk /opt/todesk/config --dev /dev \
                    --dev-bind /dev/dri /dev/dri \
                    --dev-bind /dev/shm /dev/shm \
                    --tmpfs /sys --tmpfs /tmp\
                    --ro-bind /sys/dev/char /sys/dev/char \
                    --ro-bind /sys/devices /sys/devices \
                    --proc /proc \
                    --dir /sandbox \
                    --bind /run /run \
                    --bind /usr /usr \
                    --ro-bind /etc /etc \
                    --symlink usr/lib /lib \
                    --bind /home /home \
                    --symlink usr/lib64 /lib64 \
                    --symlink usr/bin /bin \
                    --symlink usr/bin /sbin \
                    --ro-bind-try \$XAUTHORITY \$XAUTHORITY /opt/todesk/bin/ToDesk  ">> "$out/opt/todesk/bin/ToDesk-Wrap"
        chmod +x "$out/opt/todesk/bin/ToDesk-Wrap"
        echo "#! ${bash}/bin/bash -e" > "$out/opt/todesk/bin/ToDeskService-Wrap"
        echo "if [ ! -d /var/lib/todesk ]; then">> "$out/opt/todesk/bin/ToDeskService-Wrap"
        echo "mkdir /var/lib/todesk && chmod 777 /var/lib/todesk" >> "$out/opt/todesk/bin/ToDeskService-Wrap"
        echo "fi">> "$out/opt/todesk/bin/ToDeskService-Wrap"
        echo "${bubblewrap}/bin/bwrap --dev /dev --ro-bind /nix/store /nix/store --bind $out/opt/todesk/bin /opt/todesk/bin --ro-bind $out/opt/todesk/res /opt/todesk/res --bind /var/lib/todesk /opt/todesk/config --dev /dev \
                    --dev-bind /dev/dri /dev/dri \
                    --dev-bind /dev/shm /dev/shm \
                    --tmpfs /sys --tmpfs /tmp\
                    --ro-bind /sys/dev/char /sys/dev/char \
                    --ro-bind /sys/devices /sys/devices \
                    --proc /proc \
                    --dir /sandbox \
                    --bind /usr /usr \
                    --ro-bind /etc /etc \
                    --bind /home /home \
                    --symlink usr/lib /lib \
                    --bind /run /run \
                    --symlink usr/lib64 /lib64 \
                    --symlink usr/bin /bin \
                    --symlink usr/bin /sbin \
                    /opt/todesk/bin/ToDesk_Service  ">> "$out/opt/todesk/bin/ToDeskService-Wrap"

        chmod +x "$out/opt/todesk/bin/ToDeskService-Wrap"
        mkdir "$out/share"
        mkdir "$out/share/applications"
        mkdir "$out/share/icons"
        mv $out/usr/share/applications/todesk.desktop $out/share/applications
        cp -rf $out/usr/share/icons/* $out/share/icons
        substituteInPlace "$out/share/applications/todesk.desktop" \
          --replace '/opt/todesk' "$out/opt/todesk"
        substituteInPlace "$out/share/applications/todesk.desktop" \
          --replace "$out/opt/todesk/bin/ToDesk" "$out/opt/todesk/bin/ToDesk-Wrap"
        runHook postInstall
  '';

  meta = {
    description = "A Remote Desktop Application";
    homepage = "https://www.todesk.com/linux.html";
    license = lib.licenses.unfree;
    platforms = with lib.platforms; [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "ToDesk-Wrap";
  };
})
