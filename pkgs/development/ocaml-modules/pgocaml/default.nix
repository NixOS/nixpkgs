{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, camlp4
, ppx_tools_versioned, result, rresult
, calendar, csv, hex, re
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.05"
then throw "pgocaml is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-pgocaml-${version}";
  version = "3.2";
  src = fetchFromGitHub {
    owner = "darioteixeira";
    repo = "pgocaml";
    rev = "v${version}";
    sha256 = "0jxzr5niv8kdh90pr57b1qb500zkkasxb8b8l7w9cydcfprnlk24";
  };

  buildInputs = [ ocaml findlib ocamlbuild camlp4 ppx_tools_versioned result rresult ];
  propagatedBuildInputs = [ calendar csv hex re ];

  configureFlags = [ "--enable-p4" "--enable-ppx" ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    description = "An interface to PostgreSQL databases for OCaml applications";
    homepage = http://pgocaml.forge.ocamlcore.org/;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
