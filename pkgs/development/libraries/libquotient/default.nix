{ mkDerivation, lib, fetchFromGitHub, cmake, qtbase, qtmultimedia }:

mkDerivation rec {
  pname = "libquotient";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
    sha256 = "1721cy6zaq086nrwh9x4d7k1jiaygg1wkvyx486i9bj9z53lc3wd";
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
