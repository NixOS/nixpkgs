{ stdenv, lib, fetchFromGitHub, libtool, pkgconfig }:

stdenv.mkDerivation rec {
  name = "unibilium-${version}";

  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "mauke";
    repo = "unibilium";
    rev = "v${version}";
    sha256 = "1qsw19irg70l29j7qv403f32l4rrzn53w7881a6h874j9gisl51s";
  };

  makeFlags = [ "PREFIX=$(out)" ]
    ++ stdenv.lib.optional stdenv.isDarwin "LIBTOOL=${libtool}/bin/libtool";

  buildInputs = [ libtool pkgconfig ];

  meta = with lib; {
    description = "A very basic terminfo library";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
