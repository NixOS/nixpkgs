{ lib, buildDunePackage, fetchurl, cppo }:

buildDunePackage rec {
  pname = "merlin-extend";
  version = "0.6.2";

  src = fetchurl {
    url = "https://github.com/let-def/merlin-extend/releases/download/v${version}/merlin-extend-${version}.tbz";
    hash = "sha256-R1WOfzC2RGLyucgvt/eHEzrPoNUTJFK2rXhI4LD013k=";
  };

  nativeBuildInputs = [ cppo ];

  meta = with lib; {
    homepage = "https://github.com/let-def/merlin-extend";
    description = "SDK to extend Merlin";
    license = licenses.mit;
    maintainers = [ ];
  };
}
