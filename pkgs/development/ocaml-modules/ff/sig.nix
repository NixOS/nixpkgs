{ lib, fetchFromGitLab, buildDunePackage, zarith }:

buildDunePackage rec {
  pname = "ff-sig";
  version = "0.6.1";
  src = fetchFromGitLab {
    owner = "dannywillems";
    repo = "ocaml-ff";
    rev = version;
    sha256 = "0p42ivyfbn1pwm18773y4ga9cm64ysha0rplzvrnhszg01anarc0";
  };

  useDune2 = true;

  propagatedBuildInputs = [
    zarith
  ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/dannywillems/ocaml-ff";
    description = "Minimal finite field signatures";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
