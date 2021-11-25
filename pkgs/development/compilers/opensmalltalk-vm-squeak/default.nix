{ lib, stdenv, fetchurl, makeWrapper, alsa-lib, libGL, libpulseaudio, libuuid
, xorg }:

let rev = "202003021730";
in stdenv.mkDerivation rec {
  pname = "squeak";
  version = "5.0-${rev}";

  src = fetchurl {
    url =
      "https://github.com/OpenSmalltalk/opensmalltalk-vm/releases/download/${rev}/squeak.cog.spur_linux64x64_${rev}.tar.gz";
    hash = "sha256-BJv7EPfIrGpwF/I8sltol4IX+gfo3Dm6+16r/JpYi1w=";
  };

  squeakSources = fetchurl {
    url = "https://files.squeak.org/sources_files/SqueakV50.sources.gz";
    hash = "sha256-ZViZ1VgI32LwLTEyw7utp8oaAK3UmCNJnHqsGm1IKYE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    mkdir -p $out/bin

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      "lib/squeak/${version}/squeak"
    cp -r lib $out/
    gunzip < $squeakSources > $out/lib/squeak/${version}/SqueakV50.sources

    makeWrapper "$out/lib/squeak/${version}/squeak" "$out/bin/squeak" \
      --set SQUEAK_PLUGINS "$out/lib/squeak/${version}" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (with xorg; [
          stdenv.cc.libc
          alsa-lib
          libGL
          libICE
          libSM
          libX11
          libXext
          libXrender
          libpulseaudio
          libuuid
        ])
      }
  '';

  meta = with lib; {
    description = "OpenSmalltalk virtual machine for Squeak";
    homepage = "https://opensmalltalk.org/";
    license = with licenses; [ mit ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
