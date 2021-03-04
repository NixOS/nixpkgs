{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkg-config, jansson, openssl }:

stdenv.mkDerivation rec {
  pname = "libjwt";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "benmcollins";
    repo = "libjwt";
    rev = "v${version}";
    sha256 = "1c69slf9k56gh0xcg6269v712ysm6wckracms4grdsc72xg6x7h2";
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
