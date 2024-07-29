{ lib, buildDunePackage, fetchurl
, seq
, stdlib-shims
}:

buildDunePackage rec {
  pname = "ptmap";
  version = "2.0.5";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/backtracking/ptmap/releases/download/${version}/ptmap-${version}.tbz";
    sha256 = "1apk61fc1y1g7x3m3c91fnskvxp6i0vk5nxwvipj56k7x2pzilgb";
  };

  buildInputs = [ stdlib-shims ];
  propagatedBuildInputs = [ seq ];

  doCheck = true;

  meta = {
    homepage = "https://www.lri.fr/~filliatr/software.en.html";
    description = "Maps over integers implemented as Patricia trees";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
  };
}
