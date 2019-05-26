{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.1.5";
  name = "nanomsg-${version}";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nanomsg";
    rev = version;
    sha256 = "01ddfzjlkf2dgijrmm3j3j8irccsnbgfvjcnwslsfaxnrmrq5s64";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description= "Socket library that provides several common communication patterns";
    homepage = https://nanomsg.org/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
