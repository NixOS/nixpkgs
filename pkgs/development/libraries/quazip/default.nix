{ fetchFromGitHub, stdenv, zlib, qtbase, cmake, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "quazip";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "stachenov";
    repo = pname;
    rev = "v${version}";
    sha256 = "11icgwv2xyxhd1hm1add51xv54zwkcqkg85d1xqlgiigvbm196iq";
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
