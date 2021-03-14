{ lib, buildDunePackage, fetchFromGitHub, xenstore, lwt }:

buildDunePackage rec {
  pname = "xenstore_transport";
  version = "1.3.0";

  minimumOCamlVersion = "4.04";
  useDune2 = true;

  src = fetchFromGitHub {
    owner = "xapi-project";
    repo = "ocaml-xenstore-clients";
    rev = "v${version}";
    sha256 = "1kxxd9i4qiq98r7sgvl59iq2ni7y6drnv48qj580q5cyiyyc85q3";
  };

  propagatedBuildInputs = [ xenstore lwt ];

  # requires a mounted xenfs and xen server
  doCheck = false;

  meta = with lib; {
    description = "Low-level libraries for connecting to a xenstore service on a xen host";
    license = licenses.lgpl21Only;
    homepage = "http://github.com/xapi-project/ocaml-xenstore-clients";
  };
}
