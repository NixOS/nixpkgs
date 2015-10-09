{ stdenv, fetchFromGitHub, gfortran }:

stdenv.mkDerivation rec {
  name = "openspecfun-${version}";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "JuliaLang";
    repo = "openspecfun";
    rev = "v${version}";
    sha256 = "1h1pdin6p8wm9rq19bin97bnb532j8711r238mrj3pmh571zx58m";
  };

  nativeBuildInputs = [ gfortran ];

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "A collection of special mathematical functions";
    homepage = "https://github.com/JuliaLang/openspecfun";
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
    license = licenses.mit;
  };
}
