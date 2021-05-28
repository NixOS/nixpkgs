{ stdenv, fetchFromGitLab, cmake, cairo }:

stdenv.mkDerivation rec {
  pname = "redkite";
  version = "1.0.3";

  src = fetchFromGitLab {
    owner = "iurie-sw";
    repo = pname;
    rev = "v${version}";
    sha256 = "1m2db7c791fi33snkjwnvlxapmf879g5r8azlkx7sr6vp2s0jq2k";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ cairo ];

  meta = {
    homepage = "https://gitlab.com/iurie-sw/redkite";
    description = "A small GUI toolkit";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
