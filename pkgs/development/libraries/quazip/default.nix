{ fetchFromGitHub, stdenv, zlib, qtbase, cmake, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "quazip";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "stachenov";
    repo = pname;
    rev = "v${version}";
    sha256 = "1g473gnsbkvxpsv8lbsmhspn7jnq86b05zzgqh11r581v8ndvz5s";
  };

  buildInputs = [ zlib qtbase ];
  nativeBuildInputs = [ cmake ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  meta = with stdenv.lib; {
    description = "Provides access to ZIP archives from Qt programs";
    license = licenses.lgpl21Plus;
    homepage = https://stachenov.github.io/quazip/; # Migrated from http://quazip.sourceforge.net/
    platforms = with platforms; linux ++ darwin;
  };
}
