{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, camomile, react, dune, charInfo_width }:

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02" then
  {
    version = "2.0.3";
    sha256 = "0pa9awinqr0plp4b2az78dwpvh01pwaljnn5ydg8mc6hi7rmir55";
    buildInputs = [ dune ];
    propagatedBuildInputs = [ charInfo_width ];
    extra = {
     buildPhase = "dune build -p zed";
     inherit (dune) installPhase; };
  } else {
    version = "1.4";
    sha256 = "0d8qfy0qiydrrqi8qc9rcwgjigql6vx9gl4zp62jfz1lmjgb2a3w";
    buildInputs = [ ocamlbuild ];
    propagatedBuildInputs = [ camomile ];
    extra = { createFindlibDestdir = true; };
  }
; in

stdenv.mkDerivation (rec {
  inherit (param) version;
  name = "ocaml-zed-${version}";

  src = fetchzip {
    url = "https://github.com/diml/zed/archive/${version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [ ocaml findlib ] ++ param.buildInputs;

  propagatedBuildInputs = [ react ] ++ param.propagatedBuildInputs;

  meta = {
    description = "Abstract engine for text edition in OCaml";
    longDescription = ''
    Zed is an abstract engine for text edition. It can be used to write text editors, edition widgets, readlines, ...

    Zed uses Camomile to fully support the Unicode specification, and implements an UTF-8 encoded string type with validation, and a rope datastructure to achieve efficient operations on large Unicode buffers. Zed also features a regular expression search on ropes.

    To support efficient text edition capabilities, Zed provides macro recording and cursor management facilities.
    '';
    homepage = "https://github.com/diml/zed";
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };
} // param.extra)
