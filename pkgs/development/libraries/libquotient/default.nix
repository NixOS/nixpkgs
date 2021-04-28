{ mkDerivation, lib, fetchFromGitHub, cmake, qtbase, qtmultimedia }:

mkDerivation rec {
  pname = "libquotient";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
    sha256 = "sha256-QSpkcQEDTMsFbQBa7dTuL/5HraVChUHqUuJdNMty/4s=";
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
