{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocsigen-toolkit, pgocaml_ppx, safepass, yojson
, cohttp-lwt-unix, eliom
, resource-pooling
, ocsigen-ppx-rpc
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-ocsigen-start";
  version = "6.2.0";

  nativeBuildInputs = [ ocaml findlib eliom ];
  buildInputs = [ ocsigen-ppx-rpc ];
  propagatedBuildInputs = [ pgocaml_ppx safepass ocsigen-toolkit yojson resource-pooling cohttp-lwt-unix ];

  strictDeps = true;

  patches = [ ./templates-dir.patch ];

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigen-start";
    rev = version;
    hash = "sha256-i2nj/m1Ihb/bprtHvZh47/oK0v+aFNVH+A2CB4rrrPk=";
  };

  preInstall = ''
    mkdir -p $OCAMLFIND_DESTDIR
  '';

  meta = {
    homepage = "http://ocsigen.org/ocsigen-start";
    description = "Eliom application skeleton";
    longDescription =''
     An Eliom application skeleton, ready to use to build your own application with users, (pre)registration, notifications, etc.
      '';
    license = lib.licenses.lgpl21Only;
    inherit (ocaml.meta) platforms;
    maintainers = [ lib.maintainers.gal_bolle ];
  };

}
