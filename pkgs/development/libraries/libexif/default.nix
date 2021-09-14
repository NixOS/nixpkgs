{ lib, stdenv, fetchFromGitHub, autoreconfHook, gettext }:

stdenv.mkDerivation rec {
  pname = "libexif";
  version = "0.6.23";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${builtins.replaceStrings ["."] ["_"] version}-release";
    sha256 = "sha256-Os0yI/IPoe9MuhXgNdDaIg6uohclA2bjeu9t3tbUoNA=";
  };

  nativeBuildInputs = [ autoreconfHook gettext ];

  meta = with lib; {
    homepage = "https://libexif.github.io/";
    description = "A library to read and manipulate EXIF data in digital photographs";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = with maintainers; [ erictapen ];
  };

}
