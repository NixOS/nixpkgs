{ stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  name = "actor-framework-${version}";
  version = "0.15.7";

  src = fetchFromGitHub {
    owner = "actor-framework";
    repo = "actor-framework";
    rev = "${version}";
    sha256 = "0qmb18k162xdvf8z03mybjazkwb2vqda5xd1qh5bwkvxracwq3sb";
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
