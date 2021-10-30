{ mkDerivation, lib, fetchFromGitHub, cmake, qtbase, qtmultimedia }:

mkDerivation rec {
  pname = "libquotient";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
    sha256 = "sha256-1YiS2b4lYknNSB+8LKB/s6AcF0yQVsakrkp6/Sjkczo=";
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
