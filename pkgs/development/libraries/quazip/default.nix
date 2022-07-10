{ fetchFromGitHub, lib, stdenv, zlib, qtbase, qt5compat ? null, cmake, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "quazip";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "stachenov";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CtjjHJgUEmGg066D/wey3wyq8boX1sJiP7fUNmpbT1o=";
  };

  buildInputs = [ zlib qtbase ];
  propagatedBuildInputs = [ qt5compat ];
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
