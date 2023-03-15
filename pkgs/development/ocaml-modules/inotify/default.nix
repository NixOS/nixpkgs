{ lib, fetchFromGitHub, buildDunePackage
, lwt # optional lwt support
, ounit2, fileutils # only for tests
}:

buildDunePackage rec {
  version = "2.4.1";
  pname = "inotify";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "ocaml-inotify";
    rev = "v${version}";
    hash = "sha256-2ATFF3HeATjhWgW4dG4jheQ9m1oE8xTQ7mpMT/1Jdp8=";
  };

  buildInputs = [ lwt ];

  checkInputs = [ ounit2 fileutils ];

  doCheck = true;

  meta = {
    description = "Bindings for Linux’s filesystem monitoring interface, inotify";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    platforms = lib.platforms.linux;
  };
}
