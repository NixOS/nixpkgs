{ lib, fetchurl, buildDunePackage, fmt, logs }:

buildDunePackage rec {
  pname = "index";
  version = "1.0.1";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/index/releases/download/${version}/index-${version}.tbz";
    sha256 = "1006wr3g21s4j2vsd73gphhkrh1fy4swh6gqvlsa9c6q7vz9wbvz";
  };

  propagatedBuildInputs = [ fmt logs ];

  meta = {
    homepage = "https://github.com/mirage/index";
    description = "A platform-agnostic multi-level index";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
