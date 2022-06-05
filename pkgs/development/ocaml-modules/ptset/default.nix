{ lib, fetchurl, buildDunePackage
, stdlib-shims
}:

buildDunePackage rec {
  pname = "ptset";
  version = "1.0.1";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/backtracking/ptset/releases/download/${version}/ptset-${version}.tbz";
    sha256 = "1pr80mgk12l93mdq1wfsv2b6ccraxs334d5h92qzjh7bw2g13424";
  };

  doCheck = true;

  propagatedBuildInputs = [ stdlib-shims ];

  meta = {
    description = "Integer set implementation using Patricia trees";
    homepage = "https://github.com/backtracking/ptset";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
