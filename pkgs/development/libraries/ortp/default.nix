{ stdenv, fetchurl, cmake, fetchFromGitHub, bctoolbox }:

stdenv.mkDerivation rec {
  baseName = "ortp";
  version = "0.27.0";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "${baseName}";
    rev = "${version}";
    sha256 = "0gjaaph4pamay9gn1yn7ky5wyzhj93r53rwak7h8s48vf08fqyv7";
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
