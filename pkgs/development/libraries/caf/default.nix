{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "actor-framework-${version}";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "actor-framework";
    repo = "actor-framework";
    rev = "${version}";
    sha256 = "01i6sclxwa7k91ngi7jw9vlss8wjpv1hz4y5934jq0lx8hdf7s02";
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
