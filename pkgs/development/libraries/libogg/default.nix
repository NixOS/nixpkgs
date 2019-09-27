{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libogg-1.3.4";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/ogg/${name}.tar.xz";
    sha256 = "1zlk33vxvxr0l9lhkbhkdwvylw96d2n0fnd3d8dl031hph9bqqy1";
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
