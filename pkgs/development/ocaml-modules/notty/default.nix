{ lib, buildDunePackage, fetchurl, cppo
, uutf
, lwt
}:

buildDunePackage rec {
  version = "0.2.3";
  pname = "notty";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/pqwy/notty/releases/download/v${version}/notty-${version}.tbz";
    sha256 = "sha256-dGWfsUBz20Q4mJiRqyTyS++Bqkl9rBbZpn+aHJwgCCQ=";
  };

  nativeBuildInputs = [ cppo ];

  propagatedBuildInputs = [ lwt uutf ];

  meta = with lib; {
    homepage = "https://github.com/pqwy/notty";
    description = "Declarative terminal graphics for OCaml";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
