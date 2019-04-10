{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "actor-framework-${version}";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "actor-framework";
    repo = "actor-framework";
    rev = "${version}";
    sha256 = "0nqw1cv7wxbcn2qwm08qffb6k4n3kgvdiaphks5gjgm305jk4vnx";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "An open source implementation of the actor model in C++";
    homepage = http://actor-framework.org/;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bobakker ];
  };
}
