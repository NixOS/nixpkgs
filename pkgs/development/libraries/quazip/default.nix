{ fetchFromGitHub, lib, stdenv, zlib, qtbase, cmake, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "quazip";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "stachenov";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fsEMmbatTB1s8JnUYE18/vj2FZ2b40zHoOlL2OVplLc=";
  };

  buildInputs = [ zlib qtbase ];
  nativeBuildInputs = [ cmake ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Provides access to ZIP archives from Qt programs";
    license = licenses.lgpl21Plus;
    homepage = "https://stachenov.github.io/quazip/"; # Migrated from http://quazip.sourceforge.net/
    platforms = with platforms; linux ++ darwin;
  };
}
