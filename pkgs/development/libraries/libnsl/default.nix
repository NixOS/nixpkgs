{ lib, stdenv, fetchFromGitHub, autoreconfHook, libtirpc, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libnsl";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-f9kNzzR8baf5mLgrh+bKO/rBRZA5ZYc1tJdyLE7Bi1w=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libtirpc ];

  meta = with lib; {
    description = "Client interface library for NIS(YP) and NIS+";
    homepage = "https://github.com/thkukuk/libnsl";
    license = licenses.lgpl21;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
