{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "4.8.3";
  name = "libiberty-${version}";

  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.bz2";
    sha256 = "07hg10zs7gnqz58my10ch0zygizqh0z0bz6pv4pgxx45n48lz3ka";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/libiberty";

  enable_shared = 1;

  installPhase = ''
    mkdir -p $out/lib
    cp pic/libiberty.a $out/lib/libiberty_pic.a
  '';

  meta = with stdenv.lib; {
    homepage = http://gcc.gnu.org/;
    license = licenses.lgpl2;
    description = "Collection of subroutines used by various GNU programs";
    maintainers = maintainers.abbradar;
    platforms = platforms.unix;
  };
}
