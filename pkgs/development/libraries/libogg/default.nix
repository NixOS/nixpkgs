{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libogg-1.3.3";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/ogg/${name}.tar.xz";
    sha256 = "022wjlzn8fx7mfby4pcgyjwx8zir7jr7cizichh3jgaki8bwcgsg";
  };

  outputs = [ "out" "dev" "doc" ];

  meta = with stdenv.lib; {
    homepage = https://xiph.org/ogg/;
    license = licenses.bsd3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
