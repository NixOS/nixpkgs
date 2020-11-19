{ stdenv, fetchFromGitLab, cmake, cairo }:

stdenv.mkDerivation rec {
  pname = "redkite";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "iurie-sw";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c5k0a6ydb8szdgniqsva8l9j2sishlhsww13b3a9grvr7hb2bpq";
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
