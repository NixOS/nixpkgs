{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "chmlib-0.40";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "18zzb4x3z0d7fjh1x5439bs62dmgsi4c1pg3qyr7h5gp1i5xcj9l";
  };

  meta = {
    homepage = http://www.jedrea.com/chmlib;
    license = stdenv.lib.licenses.lgpl2;
    description = "A library for dealing with Microsoft ITSS/CHM format files";
    platforms = ["x86_64-linux" "i686-linux" "x86_64-darwin"];
  };
}
