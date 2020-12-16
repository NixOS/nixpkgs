{ stdenv, fetchFromGitHub, cmake, cairo }:

stdenv.mkDerivation rec {
  pname = "redkite";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "iurie-sw";
    repo = pname;
    rev = "v${version}";
    sha256 = "16j9zp5i7svq3g38rfb6h257qfgnd2brrxi7cjd2pdax9xxwj40y";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ cairo ];

  meta = with stdenv.lib; {
    homepage = "https://gitlab.com/iurie-sw/redkite";
    description = "A small GUI toolkit";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
