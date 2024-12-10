{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libogg";
  version = "1.3.5";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/ogg/${pname}-${version}.tar.xz";
    sha256 = "01b7050bghdvbxvw0gzv588fn4a27zh42ljpwzm4vrf8dziipnf4";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  meta = with lib; {
    description = "Media container library to manipulate Ogg files";
    longDescription = ''
      Library to work with Ogg multimedia container format.
      Ogg is flexible file storage and streaming format that supports
      plethora of codecs. Open format free for anyone to use.
    '';
    homepage = "https://xiph.org/ogg/";
    license = licenses.bsd3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
