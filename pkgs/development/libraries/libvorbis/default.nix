{ stdenv, fetchurl, libogg, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libvorbis-1.3.5";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/vorbis/${name}.tar.xz";
    sha256 = "1lg1n3a6r41492r7in0fpvzc7909mc5ir9z0gd3qh2pz4yalmyal";
  };

  outputs = [ "dev" "out" "doc" ];


  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ libogg ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://xiph.org/vorbis/;
    license = licenses.bsd3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
