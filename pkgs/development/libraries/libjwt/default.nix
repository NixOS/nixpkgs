{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkg-config, jansson, openssl }:

stdenv.mkDerivation rec {
  pname = "libjwt";
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "benmcollins";
    repo = "libjwt";
    rev = "v${version}";
    sha256 = "sha256-y7QX6P0EScY9MMdbwc8nDUKCxtNQCqjh9wlbxVuT6lA=";
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
