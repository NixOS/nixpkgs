{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "actor-framework";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "actor-framework";
    repo = "actor-framework";
    rev = version;
    sha256 = "1xbq591m3v6pkz4z3dg2lsxr6bxv1lpz4yhdci3vi55y6x9pwyfw";
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
