{ lib, mkDerivation, fetchFromGitHub, standard-library }:

mkDerivation rec {
  version = "0.1.7.1";
  pname = "agda-categories";

  src = fetchFromGitHub {
    owner = "agda";
    repo = "agda-categories";
    rev = "v${version}";
    sha256 = "1acb693ad2nrmnn6jxsyrlkc0di3kk2ksj2w9wnyfxrgvfsil7rn";
  };

  # Remove this once new version of agda-categories is released which
  # directly references standard-library-1.7.1
  postPatch = ''
    substituteInPlace agda-categories.agda-lib \
      --replace 'standard-library-1.7' 'standard-library-1.7.1'
  '';

  buildInputs = [ standard-library ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A new Categories library";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ alexarice turion ];
  };
}
