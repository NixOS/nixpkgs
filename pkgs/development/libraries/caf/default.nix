{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "actor-framework-${version}";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "actor-framework";
    repo = "actor-framework";
    rev = "${version}";
    sha256 = "0202nsdriigdh6sxi1k3hddvmf1x54qpykbvf2ghfhzyh0m1q7j2";
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
