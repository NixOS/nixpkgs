{ lib
, stdenv
, fetchurl
, ncurses5
, python27
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-embedded";
  version = "11.2";
  release = "11.2-2022.02";

  suffix = {
    aarch64-linux = "aarch64";
    x86_64-linux  = "x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu/${release}/binrel/gcc-arm-${release}-${suffix}-arm-none-eabi.tar.xz";
    sha256 = {
      aarch64-linux = "0pzmmdy49xgnnp17jbw76bxfwpdrnn2m976lgv5hhfafi7jq47gg";
      x86_64-linux  = "09h3qqr7abjszvnrdcff1chrydipq90njmdh8l111h37wmdcsnlc";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    cp -r * $out
    ln -s $out/share/doc/gcc-arm-none-eabi/man $out/man
  '';

  preFixup = ''
    find $out -type f | while read f; do
      patchelf "$f" > /dev/null 2>&1 || continue
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f" || true
      patchelf --set-rpath ${lib.makeLibraryPath [ "$out" stdenv.cc.cc ncurses5 python27 ]} "$f" || true
    done
  '';

  meta = with lib; {
    license = with licenses; [ bsd2 gpl2 gpl3 lgpl21 lgpl3 mit ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
