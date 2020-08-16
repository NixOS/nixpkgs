{ lib, mkDerivation, fetchFromGitHub, standard-library }:

mkDerivation rec {
  version = "0.1.3.1";
  pname = "agda-categories";

  src = fetchFromGitHub {
    owner = "agda";
    repo = "agda-categories";
    rev = "v${version}";
    sha256 = "08mc20qaz9vp5rhi60rh8wvjkg5aby3bgwwdhfnxha1663qf1q24";
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
