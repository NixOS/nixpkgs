{ lib, fetchFromGitHub, buildDunePackage, markup }:

buildDunePackage rec {
  pname = "lambdasoup";
  version = "0.6.3"; # NB: double-check the license when updating

  src = fetchFromGitHub {
    owner = "aantron";
    repo = pname;
    rev = version;
    sha256 = "1w4zp3vswijzvrx0c3fv269ncqwnvvrzc46629nnwm9shwv07vmv";
  };

  propagatedBuildInputs = [ markup ];

  meta = {
    description = "Functional HTML scraping and rewriting with CSS in OCaml";
    homepage = "https://aantron.github.io/lambdasoup/";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
