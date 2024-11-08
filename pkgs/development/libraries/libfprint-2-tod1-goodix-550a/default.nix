{ stdenv, lib, fetchzip, unzip, libfprint-tod }:

stdenv.mkDerivation {
  pname = "libfprint-2-tod1-goodix-550a";
  version = "0.0.9";

  src = fetchzip {
    url = "https://download.lenovo.com/pccbbs/mobiles/r1slg01w.zip";
    sha256 = "sha256-6tp8Unu6rs27oB5VAqfRqHmv5D9N3njl5qv6We0b/Ec=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src/libfprint-tod-goodix-550a-0.0.9.zip
    cd libfprint-tod-goodix-550a-0.0.9
    ar x libfprint-2-tod-goodix_amd64.deb
    tar xf data.tar.xz
  '';

  buildPhase = ''
    patchelf \
      --set-rpath ${lib.makeLibraryPath [ libfprint-tod ]} \
      usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-tod-goodix-550a-$version.so
  '';

  installPhase = ''
    mkdir -p "$out/lib/libfprint-2/tod-1/"
    mkdir -p "$out/lib/udev/rules.d/"

    cp usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-tod-goodix-550a-$version.so "$out/lib/libfprint-2/tod-1/"
    cp lib/udev/rules.d/60-libfprint-2-tod1-goodix.rules "$out/lib/udev/rules.d/"
  '';

  passthru.driverPath = "/lib/libfprint-2/tod-1";

  meta = with lib; {
    description = "Goodix 550a driver module for libfprint-2-tod Touch OEM Driver (from Lenovo)";
    homepage = "https://support.lenovo.com/us/en/downloads/ds560884-goodix-fingerprint-driver-for-linux-thinkpad-e14-gen-4-e15-gen-4";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ utkarshgupta137 ];
  };
}
