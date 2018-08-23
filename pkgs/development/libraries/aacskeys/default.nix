{stdenv, fetchurl, openssl, jdk, premake3}:

# Info on how to use / obtain aacs keys:
# http://vlc-bluray.whoknowsmy.name/
# https://wiki.archlinux.org/index.php/BluRay


let baseName = "aacskeys";
    version  = "0.4.0e";
in

stdenv.mkDerivation {
  name = "${baseName}-${version}";

  patchPhase = ''
    substituteInPlace "premake.lua" \
      --replace "/usr/lib/jvm/java-6-sun/include" "${jdk}/include"
  '';

  src = fetchurl {
    url = "http://deb-multimedia.org/pool/main/a/${baseName}/${baseName}_${version}.orig.tar.gz";
    sha256 = "0d3zvwixpkixfkkc16wj37h2xbcq5hsqqhqngzqr6pslmqr67vnr";
  };

  buildInputs = [openssl jdk premake3];

  installPhase = ''
    mkdir -p $out/{bin,lib,share/${baseName}}

    # Install lib
    install -Dm444 lib/linux/libaacskeys.so $out/lib

    # Install program
    install -Dm555 bin/linux/aacskeys $out/bin

    # Install resources
    install -Dm444 HostKeyCertificate.txt $out/share/${baseName}
    install -Dm444 ProcessingDeviceKeysSimple.txt $out/share/${baseName}
  '';

  meta = with stdenv.lib; {
    homepage = http://forum.doom9.org/showthread.php?t=123311;
    description = "A library and program to retrieve decryption keys for HD discs";
    platforms = platforms.linux;
    license = licenses.publicDomain;
  };
}
