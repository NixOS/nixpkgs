{ stdenv, fetchurl, patchelf }:

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  version = "3.0";
  
  date = "February2011";
  
  name = "nvidia-cg-toolkit-${version}";
  
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://developer.download.nvidia.com/cg/Cg_${version}/Cg-${version}_${date}_x86_64.tgz";
        sha256 = "07gmnzfsla3vf1kf00cj86p87h6wrdbp6ri4ycslc5kmfxsq7ypq";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://developer.download.nvidia.com/cg/Cg_${version}/Cg-${version}_${date}_x86.tgz";
        sha256 = "0hr8l0r20akbfm5j0vqv4ghl0acwjf5996pxnfxlajacl9w58nam";
      }
    else throw "nvidia-cg-toolkit does not support platform ${stdenv.system}";
    
  installPhase = ''
    for b in cgc cgfxcat cginfo
    do
        patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-*.so.? "bin/$b"
    done
    # FIXME: cgfxcat and cginfo need more patchelf
    ensureDir "$out/bin/"
    cp -v bin/* "$out/bin/"
    ensureDir "$out/include/"
    cp -v -r include/Cg/ "$out/include/"
    ensureDir "$out/lib/"
    [ "$system" = "x86_64-linux" ] && cp -v lib64/* "$out/lib/"
    [ "$system" = "i686-linux" ] && cp -v lib/* "$out/lib/"
    for mandir in man1 man3 \
      ${if stdenv.system == "x86_64-linux" then "manCg" else ""} manCgFX
    do
        ensureDir "$out/share/man/$mandir/"
        cp -v share/man/$mandir/* "$out/share/man/$mandir/"
    done
    ensureDir "$out/share/doc/$name/"
    cp -v -r local/Cg/* "$out/share/doc/$name/"
  '';
  
  meta = {
    homepage = http://developer.nvidia.com/cg-toolkit;
    license = [ "nonfree-redistributable" ];
  };
}
