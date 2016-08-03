{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "readline-5.2";

  src = fetchurl {
    url = mirror://gnu/readline/readline-5.2.tar.gz;
    sha256 = "0icz4hqqq8mlkwrpczyaha94kns0am9z0mh3a2913kg2msb8vs0j";
  };

  propagatedBuildInputs = [ncurses];

  patches = stdenv.lib.optional stdenv.isDarwin ./shobj-darwin.patch;
  meta = {
    branch = "5";
    platforms = stdenv.lib.platforms.unix;
  };
}
