{ stdenv, fetchurl, libogg, pkgconfig }:

let
  name = "libvorbis-1.3.4";
in
stdenv.mkDerivation {
  inherit name;
  
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/vorbis/${name}.tar.xz";
    sha256 = "0wpk87jnhngcl3nc5i39flkycx1sjzilx8jjx4zc4p8r55ylj19g";
  };

  buildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ libogg ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://xiph.org/vorbis/;
    license = licenses.bsd3;
    maintainers = [ maintainers.emery ];
    platforms = platforms.all;
  };
}
