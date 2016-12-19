{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.0.0";
  name = "nanomsg-${version}";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nanomsg";
    rev = version;
    sha256 = "1iqlmvz5k8m4srb120g3kfkmm1w2p16hyxmx2asvihd21j285fmw";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description= "Socket library that provides several common communication patterns";
    homepage = http://nanomsg.org/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
