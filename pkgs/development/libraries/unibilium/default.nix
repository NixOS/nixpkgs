{ stdenv, lib, fetchFromGitHub, libtool, pkgconfig }:

stdenv.mkDerivation rec {
  name = "unibilium-${version}";

  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "mauke";
    repo = "unibilium";
    rev = "v${version}";
    sha256 = "11mbfijdrvbmdlmxs8j4vij78ki0vna89yg3r9n9g1i6j45hiq2r";
  };

  makeFlags = [ "PREFIX=$(out)" ]
    ++ stdenv.lib.optional stdenv.isDarwin "LIBTOOL=${libtool}/bin/libtool";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libtool ];

  meta = with lib; {
    description = "A very basic terminfo library";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
  };
}
