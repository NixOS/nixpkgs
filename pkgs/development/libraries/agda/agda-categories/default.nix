{ lib, mkDerivation, fetchFromGitHub, standard-library }:

mkDerivation rec {
  version = "0.1.4";
  pname = "agda-categories";

  src = fetchFromGitHub {
    owner = "agda";
    repo = "agda-categories";
    rev = "v${version}";
    sha256 = "0n6y9xarqhj95i4h56klx10gy0fyckxbfwgiissfknpfq6l0m7r6";
  };

  buildInputs = [ standard-library ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A new Categories library";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ alexarice turion ];
  };
}
