{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  ocaml,
  findlib,
}:

let
  params =
    if lib.versionAtLeast ocaml.version "4.07" then
      rec {
        version = "0.2";
        src = fetchFromGitHub {
          owner = "grain-lang";
          repo = "dypgen";
          rev = version;
          hash = "sha256-fKuO/e5YbA2B7XcghWl9pXxwvKw9YlhnmZDZcuKe3cs=";
        };
      }
    else if lib.versionOlder ocaml.version "4.06" then
      {
        version = "20120619-1";
        src = fetchurl {
          url = "http://dypgen.free.fr/dypgen-20120619-1.tar.bz2";
          sha256 = "ecb53d6e469e9ec4d57ee6323ff498d45b78883ae13618492488e7c5151fdd97";
        };
      }
    else
      throw "dypgen is not available for OCaml ${ocaml.version}";
in

stdenv.mkDerivation {
  pname = "ocaml${ocaml.version}-dypgen";
  inherit (params) src version;

  nativeBuildInputs = [
    ocaml
    findlib
  ];

  strictDeps = true;

  createFindlibDestdir = true;

  buildPhase = ''
    make
  '';

  makeFlags = [
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/usr/share/man/man1"
    "DYPGENLIBDIR=$(out)/lib/ocaml/${ocaml.version}/site-lib"
  ];

  meta = {
    homepage = "http://dypgen.free.fr";
    description = "Dypgen GLR self extensible parser generator";
    license = lib.licenses.cecill-b;
    inherit (ocaml.meta) platforms;
  };
}
