{ fetchFromGitHub, lib, stdenv, zlib, qtbase, cmake, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "quazip";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "stachenov";
    repo = pname;
    rev = "v${version}";
    sha256 = "06srglrj6jvy5ngmidlgx03i0d5w91yhi7sf846wql00v8rvhc5h";
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
