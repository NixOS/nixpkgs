{ stdenv, fetchurl }:

let
  name = "libogg-1.3.2";
in
stdenv.mkDerivation {
  inherit name;
  
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/ogg/${name}.tar.xz";
    sha256 = "16z74q422jmprhyvy7c9x909li8cqzmvzyr8cgbm52xcsp6pqs1z";
  };

  meta = with stdenv.lib; {
    homepage = http://xiph.org/ogg/;
    license = licenses.bsd3;
    maintainers = [ maintainers.emery ];
    platforms = platforms.all;
  };
}
