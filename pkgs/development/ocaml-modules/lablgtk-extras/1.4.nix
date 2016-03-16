{ stdenv, fetchurl, ocaml, findlib, camlp4, config-file, lablgtk, xmlm }:

stdenv.mkDerivation {
  name = "ocaml-lablgtk-extras-1.4";
  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/1282/lablgtkextras-1.4.tar.gz;
    sha256 = "09fqxwdib7r9yxynknc9gv3jw2hnhj5cak7q5jngk6m8rzvmhfcc";
  };

  buildInputs = [ ocaml findlib camlp4 ];
  propagatedBuildInputs = [ config-file lablgtk xmlm ];

  createFindlibDestdir = true;

  meta = {
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    homepage = http://gtk-extras.forge.ocamlcore.org/;
    description = "A collection of libraries and modules useful when developing OCaml/LablGtk2 applications";
    license = stdenv.lib.licenses.lgpl2Plus;
    branch = "1.4";
  };
}
