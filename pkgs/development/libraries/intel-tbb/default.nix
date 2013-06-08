{ stdenv, fetchurl }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "intel-tbb-4.1";
  
  src = fetchurl {
    url = http://threadingbuildingblocks.org/sites/default/files/software_releases/linux/tbb41_20121003oss_lin.tgz;
    sha256 = "12vxljcgkrcyw9mm8v5vfk03nkf3bmwz60r2qbljs0hl2yrx8jml";
  };

  buildPhase = ''
    mkdir -p $out
    cp -R * $out

    for f in $out/lib/${if stdenv.system == "x86_64-linux" then "linux64" else "ia32"}/*.so.2; do
      patchelf --set-rpath ${stdenv.gcc.gcc}/lib:${stdenv.gcc.gcc}/lib64 $f
    done

    rm $out/CHANGES $out/README $out/COPYING
  '';

  dontInstall = true;

  meta = {
    homepage = http://threadingbuildingblocks.org/;
  };
}
