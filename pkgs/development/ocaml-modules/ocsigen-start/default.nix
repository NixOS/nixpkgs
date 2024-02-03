{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocsigen-toolkit, pgocaml_ppx, safepass, yojson
, cohttp-lwt-unix, eliom
, resource-pooling
, ocamlnet
, ocsigen-ppx-rpc
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-ocsigen-start";
  version = "6.1.0";

  nativeBuildInputs = [ ocaml findlib eliom ];
  buildInputs = [ ocsigen-ppx-rpc ];
  propagatedBuildInputs = [ pgocaml_ppx safepass ocsigen-toolkit yojson resource-pooling cohttp-lwt-unix ocamlnet ];

  strictDeps = true;

  patches = [ ./templates-dir.patch ];

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigen-start";
    rev = version;
    hash = "sha256-gHFPutoPYKTDsFninwBTc2WOIFd3+ghRYW2hi1y5MUs=";
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
