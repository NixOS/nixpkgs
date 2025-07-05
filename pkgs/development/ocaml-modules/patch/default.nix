{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  gitUpdater,
  alcotest,
  crowbar,
}:

buildDunePackage rec {
  pname = "patch";
  version = "2.0.0";

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "hannesm";
    repo = "patch";
    tag = "v${version}";
    hash = "sha256-xqcUZaKlbyXF2//MbCom7/pGA2ej6KHYI3rizXwoqTY=";
  };

  checkInputs = [
    alcotest
    crowbar
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Patch library purely in OCaml";
    longDescription = ''
      This is a library which parses unified diff and git diff output, and can apply a patch in memory.
    '';
    homepage = "https://github.com/hannesm/patch";
    maintainers = with lib.maintainers; [ r17x ];
    license = lib.licenses.isc;
  };
}
