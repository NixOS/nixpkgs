{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "editline-2.11";
  src = fetchurl {
    url = http://www.thrysoee.dk/editline/libedit-20080712-2.11.tar.gz;
    sha256 = "6ff51a15d1ada16c44be0f32a539b492cd3b0286c3dfa413915525f55851d1e6";
  };
  propagatedBuildInputs = [ ncurses ];
}
