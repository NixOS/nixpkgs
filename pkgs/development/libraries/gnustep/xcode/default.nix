{ gsmakeDerivation, fetchFromGitHub, make, libobjc2, base }:

gsmakeDerivation rec {
  name = "xcode-${version}";
  version = "1.0";

  makeFlags = "messages=yes";

  installFlags = "DESTDIR=$(out)";

  buildInputs = [ libobjc2 base ];

  src = fetchFromGitHub {
    owner = "gnustep";
    repo = "xcode";
    rev = "cc5016794e44f9998674120a5e4625aa09ca455a";
    sha256 = "85420f3f61091b2e4548cf5e99d886cb9c72cf07b8b9fae3eebc87e7b6b7e54a";
  };
}
