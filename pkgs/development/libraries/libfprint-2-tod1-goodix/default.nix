{ stdenv, lib, fetchgit, libfprint-tod }:
stdenv.mkDerivation {
  pname = "libfprint-2-tod1-goodix";
  version = "0.0.6";

  src = fetchgit {
    url = "https://git.launchpad.net/~oem-solutions-engineers/libfprint-2-tod1-goodix/+git/libfprint-2-tod1-goodix";
    rev = "882735c6366fbe30149eea5cfd6d0ddff880f0e4"; # droped-lp1880058 on 2020-11-25
    sha256 = "sha256-Uv+Rr4V31DyaZFOj79Lpyfl3G6zVWShh20roI0AvMPU=";
  };

  buildPhase = ''
    patchelf \
      --set-rpath ${lib.makeLibraryPath [ libfprint-tod ]} \
      usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-tod-goodix-53xc-0.0.6.so

    ldd usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-tod-goodix-53xc-0.0.6.so
  '';

  installPhase = ''
    mkdir -p "$out/lib/libfprint-2/tod-1/"
    mkdir -p "$out/lib/udev/rules.d/"

    cp usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-tod-goodix-53xc-$version.so "$out/lib/libfprint-2/tod-1/"
    cp lib/udev/rules.d/60-libfprint-2-tod1-goodix.rules "$out/lib/udev/rules.d/"
  '';

  passthru.driverPath = "/lib/libfprint-2/tod-1";

  meta = with lib; {
    description = "Goodix driver module for libfprint-2-tod Touch OEM Driver";
    homepage = "https://git.launchpad.net/~oem-solutions-engineers/libfprint-2-tod1-goodix/+git/libfprint-2-tod1-goodix/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ grahamc ];
  };
}
