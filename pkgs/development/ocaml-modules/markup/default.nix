{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ocaml,
  uchar,
  uutf,
  ounit2,
}:

buildDunePackage rec {
  pname = "markup";
  version = "1.0.3";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "aantron";
    repo = "markup.ml";
    rev = version;
    sha256 = "sha256-tsXz39qFSyL6vPYKG7P73zSEiraaFuOySL1n0uFij6k=";
  };

  propagatedBuildInputs = [
    uchar
    uutf
  ];

  checkInputs = [ ounit2 ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    homepage = "https://github.com/aantron/markup.ml/";
    description = "Pair of best-effort parsers implementing the HTML5 and XML specifications";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gal_bolle ];
  };

}
