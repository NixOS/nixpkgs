{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, topkg, opam, cmdliner, astring, fmt, result }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-alcotest-${version}";
  version = "0.7.2";

  src = fetchzip {
    url = "https://github.com/mirage/alcotest/archive/${version}.tar.gz";
    sha256 = "1qgsz2zz5ky6s5pf3j3shc4fjc36rqnjflk8x0wl1fcpvvkr52md";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam topkg ];

  propagatedBuildInputs = [ cmdliner astring fmt result ];

  inherit (topkg) buildPhase installPhase;

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/alcotest;
    description = "A lightweight and colourful test framework";
    license = stdenv.lib.licenses.isc;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
