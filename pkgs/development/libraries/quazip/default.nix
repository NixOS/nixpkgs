{ fetchFromGitHub, stdenv, zip, zlib, qtbase, qmake }:

stdenv.mkDerivation rec {
  name = "quazip-${version}";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "stachenov";
    repo = "quazip";
    rev = version;
    sha256 = "0chajfaf59js9yg743hd3pnah7r71mwj6jg695m164lxwzgyg602";
  };

  preConfigure = "cd quazip";

  buildInputs = [ zlib qtbase ];
  nativeBuildInputs = [ qmake ];

  meta = {
    description = "Provides access to ZIP archives from Qt programs";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://quazip.sourceforge.net/;
    platforms = stdenv.lib.platforms.linux;
  };
}
