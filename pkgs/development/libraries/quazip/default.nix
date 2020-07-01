{ fetchFromGitHub, stdenv, zlib, qtbase, cmake, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "quazip";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "stachenov";
    repo = pname;
    rev = "v${version}";
    sha256 = "0psvf3d9akyyx3bckc9325nmbp97xiagf8la4vhca5xn2f430fbn";
  };

  buildInputs = [ zlib qtbase ];
  nativeBuildInputs = [ cmake ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  meta = with stdenv.lib; {
    description = "Provides access to ZIP archives from Qt programs";
    license = licenses.lgpl21Plus;
    homepage = "https://stachenov.github.io/quazip/"; # Migrated from http://quazip.sourceforge.net/
    platforms = with platforms; linux ++ darwin;
  };
}
