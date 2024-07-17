{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  lwt, # optional lwt support
  ounit2,
  fileutils, # only for tests
}:

buildDunePackage rec {
  version = "2.5";
  pname = "inotify";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "ocaml-inotify";
    rev = "v${version}";
    hash = "sha256-3Ju6l6aF5eJgIZJKO0lQGXjjGDzCdX2fuwyNSAjIyAs=";
  };

  buildInputs = [ lwt ];

  checkInputs = [
    ounit2
    fileutils
  ];

  doCheck = true;

  meta = {
    description = "Bindings for Linux’s filesystem monitoring interface, inotify";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    platforms = lib.platforms.linux;
  };
}
