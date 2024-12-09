{ stdenv, lib, fetchurl, ocaml, findlib, camlp4, config-file, lablgtk, xmlm }:

stdenv.mkDerivation rec {
  pname = "ocaml-lablgtk-extras";
  version = "1.4";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/1282/lablgtkextras-${version}.tar.gz";
    sha256 = "09fqxwdib7r9yxynknc9gv3jw2hnhj5cak7q5jngk6m8rzvmhfcc";
  };

  strictDeps = true;

  nativeBuildInputs = [ ocaml findlib camlp4 ];
  propagatedBuildInputs = [ config-file lablgtk xmlm ];

  createFindlibDestdir = true;

  meta = {
    platforms = ocaml.meta.platforms or [ ];
    maintainers = with lib.maintainers; [ vbgl ];
    homepage = "http://gtk-extras.forge.ocamlcore.org/";
    description = "Collection of libraries and modules useful when developing OCaml/LablGtk2 applications";
    license = lib.licenses.lgpl2Plus;
    branch = "1.4";
  };
}
