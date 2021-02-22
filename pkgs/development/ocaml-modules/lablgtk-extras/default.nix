{ stdenv, lib, fetchFromGitHub, ocaml, findlib, camlp4, config-file, lablgtk, xmlm }:

assert lib.versionAtLeast (lib.getVersion ocaml) "4.02";

stdenv.mkDerivation rec {
  version = "1.6";
  name = "ocaml${ocaml.version}-lablgtk-extras-${version}";
  src = fetchFromGitHub {
    owner = "zoggy";
    repo = "lablgtk-extras";
    rev = "release-${version}";
    sha256 = "1bbdp5j18s582mmyd7qiaq1p08g2ag4gl7x65pmzahbhg719hjda";
  };

  buildInputs = [ ocaml findlib camlp4 ];
  propagatedBuildInputs = [ config-file lablgtk xmlm ];

  createFindlibDestdir = true;

  meta = {
    platforms = ocaml.meta.platforms or [];
    maintainers = with lib.maintainers; [ vbgl ];
    homepage = "http://gtk-extras.forge.ocamlcore.org/";
    description = "A collection of libraries and modules useful when developing OCaml/LablGtk2 applications";
    license = lib.licenses.lgpl2Plus;
  };
}
