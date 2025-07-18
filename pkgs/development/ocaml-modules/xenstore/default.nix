{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  lwt,
  ounit2,
}:

buildDunePackage rec {
  pname = "xenstore";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-xenstore";
    rev = version;
    hash = "sha256-ghzrsWM5xYpTjY8FsD3GgRTXRWp4JXovsjKALGluAJU=";
  };

  propagatedBuildInputs = [ lwt ];

  doCheck = true;
  checkInputs = [ ounit2 ];

  meta = {
    description = "Xenstore protocol in pure OCaml";
    longDescription = ''
      This repo contains:

        1. a xenstore client library, a merge of the Mirage and XCP ones

        2. a xenstore server library

        3. a xenstore server instance which runs under Unix with libxc

        4. a xenstore server instance which runs on mirage.


        The client and the server libraries have sets of unit-tests.
    '';
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ sternenseemann ];
    teams = [ lib.teams.xen ];
    homepage = "https://github.com/mirage/ocaml-xenstore";
    changelog = "https://github.com/mirage/ocaml-xenstore/releases/tag/${version}";
  };
}
