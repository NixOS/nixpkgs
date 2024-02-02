{ lib, stdenv, fetchurl, autoPatchelfHook
, alsa-lib, gcc-unwrapped, libX11, libcxx, libdrm, libglvnd, libpulseaudio, libxcb, mesa, wayland, xz, zlib
, libva, libvdpau, addOpenGLRunpath
}:

stdenv.mkDerivation rec {
  pname = "mdk-sdk";
  version = "0.24.0";

  src = fetchurl {
    url = "https://github.com/wang-bin/mdk-sdk/releases/download/v${version}/mdk-sdk-linux-x64.tar.xz";
    hash = "sha256-kRihFM2+vPg6OAL4ARz0dLLUvAFvZsbrCu5TBI6b2RI=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    alsa-lib gcc-unwrapped libX11 libcxx libdrm libglvnd libpulseaudio libxcb mesa wayland xz zlib
  ];

  appendRunpaths = lib.makeLibraryPath [
    libva libvdpau addOpenGLRunpath.driverLink
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r include $out
    cp -d lib/amd64/libmdk* $out/lib
    ln -s . $out/lib/amd64
    cp -r lib/cmake $out/lib

    runHook postInstall
  '';

  meta = with lib; {
    description = "multimedia development kit";
    homepage = "https://github.com/wang-bin/mdk-sdk";
    license = licenses.unfree;
    maintainers = with maintainers; [ orivej ];
    platforms = [ "x86_64-linux" ];
  };
}
