{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "actor-framework";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "actor-framework";
    repo = "actor-framework";
    rev = version;
    sha256 = "10dcpmdsfq6r7hpvg413pqi1q3rjvgn7f87c17ghyz30x6rjhaic";
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
