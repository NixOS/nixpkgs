{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkg-config, jansson, openssl }:

stdenv.mkDerivation rec {
  pname = "libjwt";
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "benmcollins";
    repo = "libjwt";
    rev = "v${version}";
    sha256 = "sha256-as4tqvRY559Q2R3s4GZHovqsCboXNz/NcV5lo+qCeOk=";
  };

  buildInputs = [ jansson openssl ];
  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    homepage = "https://github.com/benmcollins/libjwt";
    description = "JWT C Library";
    license = licenses.mpl20;
    maintainers = with maintainers; [ pnotequalnp ];
    platforms = platforms.all;
  };
}
