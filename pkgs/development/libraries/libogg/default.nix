{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libogg-1.3.3";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/ogg/${name}.tar.xz";
    sha256 = "022wjlzn8fx7mfby4pcgyjwx8zir7jr7cizichh3jgaki8bwcgsg";
  };

  outputs = [ "out" "dev" "doc" ];

  meta = with stdenv.lib; {
    description = "Media container library to manipulate Ogg files";
    longDescription = ''
      Library to work with Ogg multimedia container format.
      Ogg is flexible file storage and streaming format that supports
      plethora of codecs. Open format free for anyone to use.
    '';
    homepage = https://xiph.org/ogg/;
    license = licenses.bsd3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
