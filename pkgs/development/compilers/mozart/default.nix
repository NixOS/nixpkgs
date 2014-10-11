{ stdenv, fetchurl, bash, makeWrapper, coreutils, emacs, tcl, tk, boost, gmp, cacert }:

let
  version = "2.0.0";
in
stdenv.mkDerivation {
  name = "mozart-${version}";

  src = fetchurl {
    url = "http://sourceforge.net/projects/mozart-oz/files/v${version}-alpha.0/mozart2-${version}-alpha.0+build.4105.5c06ced-x86_64-linux.tar.gz";
    sha256 = "0rsfrjimjxqbwprpzzlmydl3z3aiwg5qkb052jixdxjyad7gyh5z";
  };

  libPath = stdenv.lib.makeLibraryPath
    [stdenv.gcc.gcc emacs tk tcl boost gmp];

  builder = ./builder.sh;

  buildInputs = [ makeWrapper ];

  meta = with stdenv.lib; {
    homepage = "http://www.mozart-oz.org/";
    description = "The Mozart Programming System combines ongoing research in programming language design and implementation, constraint logic programming, distributed computing, and human-computer interfaces. Mozart implements the Oz language and provides both expressive power and advanced functionality.";

    license = licenses.mit;
    platforms = platforms.unix;
  };
}
