{ mkDerivation, lib, fetchFromGitHub, cmake, qtbase, qtmultimedia }:

mkDerivation rec {
  pname = "libquotient";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
    sha256 = "sha256-TAfo4BkNHE8r32FPT2iDjddq2lk1yC9DrRGZurSO48c=";
  };

  buildInputs = [ qtbase qtmultimedia ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A Qt5 library to write cross-platfrom clients for Matrix";
    homepage = "https://matrix.org/docs/projects/sdk/quotient";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ colemickens ];
  };
}
