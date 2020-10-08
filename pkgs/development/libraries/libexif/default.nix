{ stdenv, fetchFromGitHub, autoreconfHook, gettext }:

stdenv.mkDerivation rec {
  pname = "libexif";
  version = "0.6.22";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${builtins.replaceStrings ["."] ["_"] version}-release";
    sha256 = "0mzndakdi816zcs13z7yzp7hj031p2dcyfq2p391r63d9z21jmy1";
  };

  nativeBuildInputs = [ autoreconfHook gettext ];

  meta = with stdenv.lib; {
    homepage = "https://libexif.github.io/";
    description = "A library to read and manipulate EXIF data in digital photographs";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = with maintainers; [ erictapen ];
  };

}
