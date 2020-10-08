{ lib, fetchFromGitHub, buildDunePackage, markup }:

buildDunePackage rec {
  pname = "lambdasoup";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = pname;
    rev = version;
    sha256 = "14lndpsnzjjg58sdwxqpsv7kz77mnwn5658lya9jyaclj8azmaks";
  };

  propagatedBuildInputs = [ markup ];

  meta = {
    description = "Functional HTML scraping and rewriting with CSS in OCaml";
    homepage = "https://aantron.github.io/lambdasoup/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
