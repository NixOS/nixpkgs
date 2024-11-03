{ stdenv, lib, fetchgit, libfprint-tod, openssl }:

stdenv.mkDerivation {
  pname = "libfprint-2-tod1-broadcom";
  version = "22.04";

  src = fetchgit {
    url = "https://git.launchpad.net/~oem-solutions-engineers/libfprint-2-tod1-broadcom/+git/libfprint-2-tod1-broadcom";
    rev = "86acc29291dbaf6216b7fadf50ef1e7222f6eb2a"; # Head of 'jammy' 22.04 branch
    sha256 = "sha256-nCkAqAi1AD3qMIU3maMuOUY6zG6+wDkqUMaHEKcLTko=";
  };

  buildPhase = ''
    patchelf \
      --set-rpath ${lib.makeLibraryPath [ libfprint-tod openssl ]} \
      usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-2-tod-1-broadcom.so
  '';

  installPhase = ''
    mkdir -p "$out/lib/libfprint-2/tod-1/"
    mkdir -p "$out/lib/udev/rules.d/"
    mkdir -p "$out/var/lib/fprint/fw/"

    cp usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-2-tod-1-broadcom.so "$out/lib/libfprint-2/tod-1/"
    cp lib/udev/rules.d/60-libfprint-2-device-broadcom.rules "$out/lib/udev/rules.d/"
    cp var/lib/fprint/fw/* "$out/var/lib/fprint/fw/"
  '';

  passthru.driverPath = "/lib/libfprint-2/tod-1";

  meta = with lib; {
    description = "Broadcom driver module for libfprint-2-tod Touch OEM Driver";
    homepage = "https://git.launchpad.net/~oem-solutions-engineers/libfprint-2-tod1-broadcom/+git/libfprint-2-tod1-broadcom/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ grahamc ];
  };
}
