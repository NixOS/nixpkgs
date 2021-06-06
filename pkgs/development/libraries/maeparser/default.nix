{ fetchFromGitHub
, lib
, stdenv
, boost
, zlib
, cmake
}:

stdenv.mkDerivation rec {
  pname = "maeparser";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = "maeparser";
    rev = "v${version}";
    sha256 = "1qzp8d58ksy88y4fx1b0x65wycslm7zxzbb8ns28gkjh12xpzhwz";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost zlib ];

  meta = with lib; {
    description = "maestro file parser";
    maintainers = [ maintainers.rmcgibbo ];
    license = licenses.mit;
  };
}
