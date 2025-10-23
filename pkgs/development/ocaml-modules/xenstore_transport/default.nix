{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  xenstore,
  lwt,
}:

buildDunePackage rec {
  pname = "xenstore_transport";
  version = "1.5.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "xapi-project";
    repo = "ocaml-xenstore-clients";
    rev = "v${version}";
    sha256 = "sha256-tnz+dZ3EdzDVTGAe4y7OveXuVEUSh1aJxJabHM4zHTI=";
  };

  propagatedBuildInputs = [
    xenstore
    lwt
  ];

  # requires a mounted xenfs and xen server
  doCheck = false;

  meta = with lib; {
    description = "Low-level libraries for connecting to a xenstore service on a xen host";
    license = licenses.lgpl21Only;
    homepage = "https://github.com/xapi-project/ocaml-xenstore-clients";
    teams = [ teams.xen ];
  };
}
