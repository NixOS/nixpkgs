{ stdenv, fetchurl, ocaml, findlib, camlp4, config-file, lablgtk, xmlm }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02";

stdenv.mkDerivation {
  name = "ocaml-lablgtk-extras-1.5";
  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1453/lablgtkextras-1.5.tar.gz;
    sha256 = "1bgflgadmy2nqnqjf34zja0jy6f9wpqq8x22qcfilj9g8c9wkrmi";
  };

  buildInputs = [ ocaml findlib camlp4 ];
  propagatedBuildInputs = [ config-file lablgtk xmlm ];

  createFindlibDestdir = true;

  meta = {
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    homepage = http://gtk-extras.forge.ocamlcore.org/;
    description = "A collection of libraries and modules useful when developing OCaml/LablGtk2 applications";
    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
