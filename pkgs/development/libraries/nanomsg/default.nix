{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.1.3";
  name = "nanomsg-${version}";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nanomsg";
    rev = version;
    sha256 = "0mckz63rm0hpnln7mkg79bwiybydzbxyzyb39y2m1bjj8xwxkp2m";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description= "Socket library that provides several common communication patterns";
    homepage = http://nanomsg.org/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
