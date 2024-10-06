{ lib
, stdenv
, fetchgit
, libfprint-tod
, openssl
}:

stdenv.mkDerivation {
  pname = "libfprint-2-tod1-broadcom";
  version = "5.12.018.0";

  src = fetchgit {
    url = "https://git.launchpad.net/~oem-solutions-engineers/libfprint-2-tod1-broadcom/+git/libfprint-2-tod1-broadcom";
    rev = "86acc29291dbaf6216b7fadf50ef1e7222f6eb2a";
    hash = "sha256-nCkAqAi1AD3qMIU3maMuOUY6zG6+wDkqUMaHEKcLTko=";
  };

  buildPhase = let
    # We prepare our library path in the let clause to avoid it become part of the input of mkDerivation
    libPath = lib.makeLibraryPath [
      # libfprint-2-tod.so.1
      libfprint-tod
      # libcrypto.so.3
      openssl
    ];
  in ''
    patchelf --set-rpath "${libPath}" \
      usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-2-tod-1-broadcom.so
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/libfprint-2/tod-1/"
    mkdir -p "$out/lib/udev/rules.d/"
    mkdir -p "$out/var/lib/fprint/fw/"
    mkdir -p "$out/bin/"

    cp usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-2-tod-1-broadcom.so "$out/lib/libfprint-2/tod-1/"
    cp lib/udev/rules.d/60-libfprint-2-device-broadcom.rules "$out/lib/udev/rules.d/"
    cp var/lib/fprint/fw/* "$out/var/lib/fprint/fw/"
    cp debian/update-fw.py "$out/bin/"

    runHook postInstall
  '';

  passthru.driverPath = "/lib/libfprint-2/tod-1";

  meta = with lib; {
    description = "Proprietary driver for the fingerprint reader on a few Dell Latitude models - direct from Dell's Ubuntu repo";
    homepage = "https://git.launchpad.net/~oem-solutions-engineers/libfprint-2-tod1-broadcom/+git/libfprint-2-tod1-broadcom/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ totoroot ];
  };
}
