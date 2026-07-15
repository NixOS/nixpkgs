{
  lib,
  buildDunePackage,
  replaceVars,
  base64,
  cmdliner,
  digestif,
  git-unix,
  kicadsch,
  lwt,
  lwt_ppx,
  sha,
  tyxml,
  coreutils,
  imagemagick,
}:

buildDunePackage {
  pname = "plotkicadsch";
  duneVersion = "3";

  inherit (kicadsch) src version;

  minimalOCamlVersion = "4.09";

  patches = [
    (replaceVars ./fix-paths.patch {
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

  meta = {
    description = "Tool to export Kicad Sch files to SVG pictures";
    homepage = "https://github.com/jnavila/plotkicadsch";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ leungbk ];
  };
}
