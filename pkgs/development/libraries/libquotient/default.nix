{ mkDerivation, lib, fetchFromGitHub, cmake, qtbase, qtmultimedia }:

mkDerivation rec {
  pname = "libquotient";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
    sha256 = "1wpjrihi2gci3kwq9b3i3avd6bk3x7g22r0n6hvlphapkaf1ig6y";
  };

  buildInputs = [ qtbase qtmultimedia ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A Qt5 library to write cross-platfrom clients for Matrix";
    homepage = "https://matrix.org/docs/projects/sdk/quotient";
    maintainers = with maintainers; [ colemickens ];
    license = licenses.lgpl21;
  };
}
