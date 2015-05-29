{ stdenv, fetchurl, unzip, glibc }:

let
  openjdkVersion = "8";
  openjdkUpdate = "45";
  zuluMajorVersion = "8.7";
  zuluMinorVersion = "0.5";
in

stdenv.mkDerivation rec {
  name = "azul-zulu";
  version = "1.${openjdkVersion}.0_${openjdkUpdate}-${zuluMajorVersion}.${zuluMinorVersion}";

  src = fetchurl {
    url = "http://cdn.azulsystems.com/zulu/2015-04-${zuluMajorVersion}-bin/zulu${version}-x86lx64.zip";
    sha256 = "04cngsbflv65js5drmqfwgvi2ld62v6dwvg8mm3azm5z2d71r86w";
    curlOpts = "--referer http://www.azulsystems.com/products/zulu/downloads";
  };

  buildInputs = [ unzip ];

  preFixup = ''
    for p in $out/bin\/*; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $p
    done
  '';

  installPhase = ''
    mkdir -p $out
    cp -R bin lib man $out
    cp -R jre $out
  '';
  
}
  
