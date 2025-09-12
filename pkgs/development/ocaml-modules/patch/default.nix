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
  version = "3.0.0";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "hannesm";
    repo = "patch";
    tag = "v${version}";
    hash = "sha256-WIleUxfGp8cvQHYAyRRI6S/MSP4u0BbEyAqlRxCb/To=";
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
