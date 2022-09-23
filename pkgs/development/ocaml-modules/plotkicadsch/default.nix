{ lib
, buildDunePackage
, fetchFromGitHub
, substituteAll
, base64
, cmdliner
, digestif
, git-unix
, kicadsch
, lwt
, lwt_ppx
, sha
, tyxml
, coreutils
, imagemagick
}:

buildDunePackage rec {
  pname = "plotkicadsch";

  inherit (kicadsch) src version;

  minimalOCamlVersion = "4.09";

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit coreutils imagemagick;
    })
  ];

  buildInputs = [
    base64
    cmdliner
    digestif
    git-unix
    kicadsch
    lwt
    lwt_ppx
    sha
    tyxml
  ];

  meta = with lib; {
    description = "A tool to export Kicad Sch files to SVG pictures";
    homepage = "https://github.com/jnavila/plotkicadsch";
    license = licenses.isc;
    maintainers = with maintainers; [ leungbk ];
  };
}
