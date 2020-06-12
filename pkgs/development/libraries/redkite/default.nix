{ stdenv, fetchFromGitLab, cmake, cairo }:

stdenv.mkDerivation rec {
  pname = "redkite";
  version = "1.0.1";

  src = fetchFromGitLab {
    owner = "iurie-sw";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qd4r7ps0fg2m1vx3j48chfdh2c5909j4f9wip4af59inrid4w6a";
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
