{ lib
, buildDunePackage
, fetchurl
, ppxlib
, rio
, sedlex
, spices
, uutf
, qcheck
}:

buildDunePackage rec {
  pname = "bytestring";
  version = "0.0.8";

  minimalOCamlVersion = "5.1";

  src = fetchurl {
    url = "https://github.com/riot-ml/riot/releases/download/${version}/riot-${version}.tbz";
    hash = "sha256-SsiDz53b9bMIT9Q3IwDdB3WKy98WSd9fiieU41qZpeE=";
  };

  propagatedBuildInputs = [
    ppxlib
    sedlex
    spices
    rio
    uutf
  ];

  checkInputs = [
    qcheck
  ];

  # Checks fail with OCaml 5.2
  doCheck = false;

  meta = {
    description = "Efficient, immutable, pattern-matchable, UTF friendly byte strings";
    homepage = "https://github.com/riot-ml/riot";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

