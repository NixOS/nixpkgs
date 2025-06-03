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

  meta = with lib; {
    description = "Xenstore protocol in pure OCaml";
    license = licenses.lgpl21Only;
    maintainers = [ maintainers.sternenseemann ];
    teams = [ teams.xen ];
    homepage = "https://github.com/mirage/ocaml-xenstore";
  };
}
