{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkg-config, jansson, openssl }:

stdenv.mkDerivation rec {
  pname = "libjwt";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "benmcollins";
    repo = "libjwt";
    rev = "v${version}";
    sha256 = "sha256-hS10Ecq0VVuYLDrBu4x+Y2mz6eeJV1SvnqttgbiQbi0=";
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
