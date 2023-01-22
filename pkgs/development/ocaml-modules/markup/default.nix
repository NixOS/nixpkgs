{ lib, buildDunePackage, fetchFromGitHub, ocaml, uchar, uutf, ounit2 }:

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

  propagatedBuildInputs = [ uchar uutf ];

  nativeCheckInputs = [ ounit2 ];
  doCheck = lib.versionAtLeast ocaml.version "4.04";

  meta = with lib; {
    homepage = "https://github.com/aantron/markup.ml/";
    description = "A pair of best-effort parsers implementing the HTML5 and XML specifications";
    license = licenses.mit;
    maintainers = with maintainers; [ gal_bolle ];
  };

}
