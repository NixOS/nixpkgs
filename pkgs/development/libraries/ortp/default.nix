{ stdenv, cmake, fetchFromGitHub, bctoolbox }:

stdenv.mkDerivation rec {
  baseName = "ortp";
  version = "1.0.2";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "${baseName}";
    rev = "${version}";
    sha256 = "12cwv593bsdnxs0zfcp07vwyk7ghlz2wv7vdbs1ksv293w3vj2rv";
  };

  buildInputs = [ bctoolbox ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A Real-Time Transport Protocol (RFC3550) stack";
    homepage = http://www.linphone.org/index.php/eng/code_review/ortp;
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
