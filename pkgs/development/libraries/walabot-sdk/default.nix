{ stdenv, fetchurl, dpkg }:

stdenv.mkDerivation rec {
  name = "walabot-sdk-${version}";
  version = "1.0.34";

  src = fetchurl {
    url = "https://s3.eu-central-1.amazonaws.com/walabot/WalabotInstaller/Latest/walabot_maker_${version}_linux_x64.deb";
    sha256 = "08zab14z6f4i9161b3il1v4888lds9xfh48b9a2hd1n8wg7s44wh";
  };

  sourceRoot = ".";
  unpackCmd = "${dpkg}/bin/dpkg -x \"$src\" .";

  buildPhase = ":"; # nothing to build

  installPhase = ''
    mkdir $out
    cp -r usr/{include,lib} var $out/
  '';

  preFixup = let
    libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc.lib ];
  in ''
    patchelf --set-rpath "${libPath}" $out/lib/libWalabotAPI.so
  '';

  meta = with stdenv.lib; {
    homepage = https://walabot.com/;
    description = "Library for the Walabot";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.geistesk ];
  };
}
