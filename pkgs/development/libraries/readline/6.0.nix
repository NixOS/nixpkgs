args: with args;

stdenv.mkDerivation {
  name = "readline-6.0";
  src = fetchurl {
    url = mirror://gnu/readline/readline-6.0.tar.gz;
    sha256 = "1pn13j6f9376kwki69050x3zh62yb1w31l37rws5nwr5q02xk68i";
  };
  propagatedBuildInputs = [ncurses];
  configureFlags = "--enable-shared --disable-static";
  patches = stdenv.lib.optional stdenv.isDarwin ./shobj-darwin.patch;
}
