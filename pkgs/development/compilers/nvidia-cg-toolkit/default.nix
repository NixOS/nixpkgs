{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.1";

  date = "April2012";

  pname = "nvidia-cg-toolkit";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://developer.download.nvidia.com/cg/Cg_${version}/Cg-${version}_${date}_x86_64.tgz";
        sha256 = "e8ff01e6cc38d1b3fd56a083f5860737dbd2f319a39037528fb1a74a89ae9878";
      }
    else if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        url = "http://developer.download.nvidia.com/cg/Cg_${version}/Cg-${version}_${date}_x86.tgz";
        sha256 = "cef3591e436f528852db0e8c145d3842f920e0c89bcfb219c466797cb7b18879";
      }
    else throw "nvidia-cg-toolkit does not support platform ${stdenv.hostPlatform.system}";

  installPhase = ''
    for b in cgc cgfxcat cginfo
    do
        patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux*.so.? "bin/$b"
    done
    # FIXME: cgfxcat and cginfo need more patchelf
    mkdir -p "$out/bin/"
    cp -v bin/* "$out/bin/"
    mkdir -p "$out/include/"
    cp -v -r include/Cg/ "$out/include/"
    mkdir -p "$out/lib/"
    [ "$system" == "x86_64-linux" ] && cp -v lib64/* "$out/lib/"
    [ "$system" == "i686-linux" ] && cp -v lib/* "$out/lib/"
    mkdir -p "$out/share/doc/$name/"
    cp -v -r local/Cg/* "$out/share/doc/$name/"
  '';

  meta = {
    homepage = "https://developer.nvidia.com/cg-toolkit";
    license = lib.licenses.unfreeRedistributable;
  };
}
