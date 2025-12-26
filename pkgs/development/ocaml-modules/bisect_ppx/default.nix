{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildDunePackage,
  cmdliner,
  ppxlib,
}:

buildDunePackage rec {
  pname = "bisect_ppx";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = "bisect_ppx";
    rev = version;
    hash = "sha256-3qXobZLPivFDtls/3WNqDuAgWgO+tslJV47kjQPoi6o=";
  };

  # Ensure compatibility with ppxlib 0.36
  patches = lib.optionals (lib.versionAtLeast ppxlib.version "0.36") [
    (fetchpatch {
      url = "https://github.com/aantron/bisect_ppx/commit/f35fdf4bdcb82c308d70f7c9c313a77777f54bdf.patch";
      hash = "sha256-hQMDU6zrHDV9JszGAj2p4bd9zlqqjc1TLU+cfMEgz9c=";
    })
    (fetchpatch {
      url = "https://github.com/aantron/bisect_ppx/commit/07bfceec652773de4b140cebc236a15e2429809e.patch";
      hash = "sha256-9gDIndPIZMkIkd847qd2QstsZJInBPuWXAUIzZMkHcw=";
    })
    (fetchpatch {
      url = "https://github.com/aantron/bisect_ppx/commit/4f0cb2a2e1b0b786b6b5f1c94985b201aa012f12.patch";
      hash = "sha256-20nr7ApKPnnol0VEOirwXdJX+AiFRzBzAq4YzCWn7W0=";
    })
  ];

  minimalOCamlVersion = "4.11";

  buildInputs = [
    cmdliner
    ppxlib
  ];

  meta = {
    description = "Bisect_ppx is a code coverage tool for OCaml and Reason. It helps you test thoroughly by showing what's not tested";
    homepage = "https://github.com/aantron/bisect_ppx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
    mainProgram = "bisect-ppx-report";
  };
}
