{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  version = "2.1.0";
  pname = "half";

  src = fetchzip {
    url = "mirror://sourceforge/half/${version}/half-${version}.zip";
    sha256 = "04v4rhs1ffd4c9zcnk4yjhq0gdqy020518wb7n8ryk1ckrdd7hbm";
    stripRoot = false;
  };

  buildCommand = ''
    mkdir -p $out/include $out/share/doc
    cp $src/include/half.hpp               $out/include/
    cp $src/{ChangeLog,LICENSE,README}.txt $out/share/doc/
  '';

  meta = with stdenv.lib; {
    description = "C++ library for half precision floating point arithmetics";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = [ maintainers.volth ];
  };
}
