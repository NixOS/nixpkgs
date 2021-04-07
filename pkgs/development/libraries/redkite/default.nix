{ lib, stdenv, fetchFromGitHub, cmake, cairo }:

stdenv.mkDerivation rec {
  pname = "redkite";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "iurie-sw";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bf8kz9RyhDDuUHKiKvLiQLBIEXbIyoy3yuKfSpSYYv0=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ cairo ];

  meta = with lib; {
    homepage = "https://gitlab.com/iurie-sw/redkite";
    description = "A small GUI toolkit";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
