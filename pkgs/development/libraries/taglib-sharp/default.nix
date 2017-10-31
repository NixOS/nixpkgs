{ stdenv, fetchFromGitHub, autoreconfHook, which, pkgconfig, mono }:

stdenv.mkDerivation rec {
  name = "taglib-sharp-${version}";
  version = "2.1.0.0";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "taglib-sharp";

    rev = "taglib-sharp-${version}";
    sha256 = "12pk4z6ag8w7kj6vzplrlasq5lwddxrww1w1ya5ivxrfki15h5cp";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook which ];
  buildInputs = [ mono ];

  dontStrip = true;

  configureFlags = [ "--disable-docs" ];

  meta = with stdenv.lib; {
    description = "Library for reading and writing metadata in media files";
    platforms = platforms.linux;
  };
}
