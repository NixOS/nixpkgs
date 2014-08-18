{stdenv, fetchurl, ocaml, pkgconfig, findlib, SDL, SDL_image, SDL_mixer, SDL_ttf, SDL_gfx, lablgl }: 

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "ocamlsdl";
  version = "0.9.1";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl { 
    url = "http://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz";
    sha256 = "abfb295b263dc11e97fffdd88ea1a28b46df8cc2b196777093e4fe7f509e4f8f";
  };

  buildInputs = [ocaml pkgconfig findlib SDL SDL_image SDL_mixer SDL_ttf SDL_gfx lablgl];

  propagatedBuildInputs = [ SDL SDL_image SDL_mixer SDL_ttf SDL_gfx pkgconfig ];
  createFindlibDestdir = true;

  meta = {
    homepage = http://ocamlsdl.sourceforge.net/;
    description = "OCaml bindings for SDL 1.2";
    license = "LGPL 2.1";
  };
}
