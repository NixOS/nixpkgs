{ lib, buildDunePackage, fetchurl
, mtime, terminal_size, alcotest, astring, fmt
}:

buildDunePackage rec {
  pname = "progress";
  version = "0.1.1";

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/CraigFe/progress/releases/download/${version}/progress-${version}.tbz";
    sha256 = "90c6bec19d014a4c6b0b67006f08bdfcf36981d2176769bebe0ccd75d6785a32";
  };

  propagatedBuildInputs = [ mtime terminal_size ];

  doCheck = true;
  checkInputs = [ alcotest astring fmt ];

  meta = with lib; {
    description = "Progress bar library for OCaml";
    homepage = "https://github.com/CraigFe/progress";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
