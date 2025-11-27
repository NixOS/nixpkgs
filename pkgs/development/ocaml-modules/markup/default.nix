{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ocaml,
  uchar,
  uutf,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "markup";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = "markup.ml";
    tag = finalAttrs.version;
    hash = "sha256-tsXz39qFSyL6vPYKG7P73zSEiraaFuOySL1n0uFij6k=";
  };

  propagatedBuildInputs = [
    uchar
    uutf
  ];

  checkInputs = [ ounit2 ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/aantron/markup.ml/";
    description = "Pair of best-effort parsers implementing the HTML5 and XML specifications";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gal_bolle ];
  };

})
