{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
}:

if lib.versionAtLeast ocaml.version "4.06" then
  throw "cryptgps is not available for OCaml ${ocaml.version}"
else

  stdenv.mkDerivation {
    pname = "ocaml-cryptgps";
    version = "0.2.1";

    src = fetchurl {
      url = "https://download.camlcity.org/download/cryptgps-0.2.1.tar.gz";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

    nativeBuildInputs = [
      ocaml
      findlib
    ];

    strictDeps = true;

    dontConfigure = true; # Skip configure phase

    createFindlibDestdir = true;

    meta = {
      homepage = "http://projects.camlcity.org/projects/cryptgps.html";
      description = "Cryptographic functions for OCaml";
      longDescription = ''
        This library implements the symmetric cryptographic algorithms
        Blowfish, DES, and 3DES. The algorithms are written in O'Caml,
        i.e. this is not a binding to some C library, but the implementation
        itself.
      '';
      license = lib.licenses.mit;
      inherit (ocaml.meta) platforms;
      maintainers = [
        lib.maintainers.maggesi
      ];
    };
  }
