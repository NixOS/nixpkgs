{ mkDerivation, lib, fetchFromGitHub, cmake, qtbase, qtmultimedia }:

mkDerivation rec {
  pname = "libquotient";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
    sha256 = "sha256-CrAK0yq1upB1+C2z6mqKkSArCmzI+TDEEHTIBWB29Go=";
  };

  buildInputs = [ qtbase qtmultimedia ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A Qt5 library to write cross-platform clients for Matrix";
    homepage = "https://matrix.org/docs/projects/sdk/quotient";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ colemickens ];
  };
}
