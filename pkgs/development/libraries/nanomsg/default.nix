{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.1.2";
  name = "nanomsg-${version}";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nanomsg";
    rev = version;
    sha256 = "1zvs91afsg61azfv5fldv84gnhf76w3yndkdvpvaprlacxbxdvf5";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description= "Socket library that provides several common communication patterns";
    homepage = http://nanomsg.org/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
