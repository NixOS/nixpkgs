{stdenv, lib, fetchurl, ocaml, pkg-config, findlib, SDL, SDL_image, SDL_mixer, SDL_ttf, SDL_gfx, lablgl }:

let
  pname = "ocamlsdl";
in

if lib.versionAtLeast ocaml.version "4.06"
then throw "${pname} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "0.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz";
    sha256 = "abfb295b263dc11e97fffdd88ea1a28b46df8cc2b196777093e4fe7f509e4f8f";
  };

  nativeBuildInputs = [ pkg-config ocaml findlib ];
  buildInputs = [ SDL SDL_image SDL_mixer SDL_ttf SDL_gfx lablgl ];

  propagatedBuildInputs = [ SDL SDL_image SDL_mixer SDL_ttf SDL_gfx pkg-config ];
  createFindlibDestdir = true;

  meta = {
    homepage = "http://ocamlsdl.sourceforge.net/";
    description = "OCaml bindings for SDL 1.2";
    license = lib.licenses.lgpl21;
  };
}
