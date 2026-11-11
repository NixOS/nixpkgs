{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  ocaml,
  findlib,
  ocaml_pcre,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-inifiles";
  version = "1.2";

  src = fetchurl {
    url = "mirror://ubuntu/pool/universe/o/ocaml-inifiles/ocaml-inifiles_${version}.orig.tar.gz";
    hash = "sha256-2s7aAmzjml/P86AXHxevbDMQ3Tk43h+25tDAen18H0o=";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/ocaml-inifiles/ocaml-inifiles.1.2/files/ocaml-inifiles.diff";
      hash = "sha256-lr/2m0ItJTKv0qdce+phv9N5aW/Ta74RPyhoccKY8ww=";
    })
  ];

  postPatch = ''
    substituteInPlace inifiles.ml --replace 'String.lowercase ' 'String.lowercase_ascii '
  '';

  nativeBuildInputs = [
    ocaml
    findlib
  ];
  propagatedBuildInputs = [ ocaml_pcre ];

  strictDeps = true;

  buildFlags = [
    "all"
    "opt"
  ];

  createFindlibDestdir = true;

  meta = {
    description = "Small OCaml library to read and write .ini files";
    license = lib.licenses.lgpl21Plus;
    inherit (ocaml.meta) platforms;
  };
}
