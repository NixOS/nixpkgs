{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocsigen-toolkit, pgocaml_ppx, safepass, yojson
, cohttp-lwt-unix, eliom
, resource-pooling
, ocamlnet
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-ocsigen-start";
  version = "4.3.0";

  nativeBuildInputs = [ ocaml findlib eliom ];
  propagatedBuildInputs = [ pgocaml_ppx safepass ocsigen-toolkit yojson resource-pooling cohttp-lwt-unix ocamlnet ];

  strictDeps = true;

  patches = [ ./templates-dir.patch ];

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigen-start";
    rev = version;
    sha256 = "0lkl59dwzyqq2lyr46fyjr27ms0fp9h59xfsn37faaavdd7v0h98";
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
