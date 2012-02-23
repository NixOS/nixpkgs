{stdenv, fetchurl, openssl, jdk, premake}:

# Info on how to use / obtain aacs keys:
# http://vlc-bluray.whoknowsmy.name/
# https://wiki.archlinux.org/index.php/BluRay


let baseName = "aacskeys";
    version  = "0.4.0c";
in

stdenv.mkDerivation {
  name = "${baseName}-${version}";

  patchPhase = ''
    substituteInPlace "premake.lua" \
      --replace "/usr/lib/jvm/java-6-sun/include" "${jdk}/include"
  '';

  src = fetchurl {
    url = "http://debian-multimedia.org/pool/main/a/${baseName}/${baseName}_${version}.orig.tar.gz";
    sha256 = "54ea78898917f4acaf78101dda254de56bc7696bad12cbf22ee6f09d4ee88a43";
  };

  buildInputs = [openssl jdk premake];

  installPhase = ''
    ensureDir $out/{bin,lib,share/${baseName}}

    # Install lib
    install -Dm444 lib/linux/libaacskeys.so $out/lib

    # Install program
    install -Dm555 bin/linux/aacskeys $out/bin

    # Install resources
    install -Dm444 HostKeyCertificate.txt $out/share/${baseName}
    install -Dm444 ProcessingDeviceKeysSimple.txt $out/share/${baseName}
  '';

  meta = {
    homepage = http://forum.doom9.org/showthread.php?t=123311;
    description = "A library and program to retrieve decryption keys for HD discs";
  };
}
