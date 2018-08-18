{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.1.4";
  name = "nanomsg-${version}";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nanomsg";
    rev = version;
    sha256 = "11mxbhkxkzqwdmpl79mfiiqby7zawgkalips7zr0bbdfyhq7jyrl";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description= "Socket library that provides several common communication patterns";
    homepage = https://nanomsg.org/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
