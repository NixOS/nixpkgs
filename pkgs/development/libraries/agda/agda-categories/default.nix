{ lib, mkDerivation, fetchFromGitHub, standard-library }:

mkDerivation rec {
  version = "0.1.4";
  pname = "agda-categories";

  src = fetchFromGitHub {
    owner = "agda";
    repo = "agda-categories";
    rev = "v${version}";
    sha256 = "1bcvmxcnl1ig38fxqkx8ydidhxq6a0kn2k9waf0lygh4ap928sgk";
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
