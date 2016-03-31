{ stdenv, fetchurl, staticBuild ? false }:

stdenv.mkDerivation rec {
  version = "4.9.3";
  name = "libiberty-${version}";

  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.bz2";
    sha256 = "0zmnm00d2a1hsd41g34bhvxzvxisa2l584q3p447bd91lfjv4ci3";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/libiberty";

  enable_shared = !staticBuild;

  installPhase = ''
    mkdir -p $out/lib $out/include
    cp ../include/libiberty.h $out/include/
    if [ -z "$enabled_shared" ]; then
      cp libiberty.a $out/lib/libiberty.a
    else
      cp pic/libiberty.a $out/lib/libiberty_pic.a
    fi
  '';

  meta = with stdenv.lib; {
    homepage = http://gcc.gnu.org/;
    license = licenses.lgpl2;
    description = "Collection of subroutines used by various GNU programs";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
