{ lib, mkDerivation, fetchFromGitHub, standard-library }:

mkDerivation rec {
  version = "0.1.6";
  pname = "agda-categories";

  src = fetchFromGitHub {
    owner = "agda";
    repo = "agda-categories";
    rev = "v${version}";
    sha256 = "1s75yqcjwj13s1m3fg29krnn05lws6143ccfdygc6c4iynvvznsh";
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
