{ lib, stdenv, fetchzip, ocaml, findlib, libffi, pkg-config, ncurses, integers, bigarray-compat }:

if !lib.versionAtLeast ocaml.version "4.02"
then throw "ctypes is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ctypes-${version}";
  version = "0.18.0";

  src = fetchzip {
    url = "https://github.com/ocamllabs/ocaml-ctypes/archive/${version}.tar.gz";
    sha256 = "03zrbnl16m67ls0yfhq7a4k4238x6x6b3m456g4dw2yqwc153vks";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ocaml findlib ncurses ];
  propagatedBuildInputs = [ integers libffi bigarray-compat ];

  buildPhase =  ''
     make XEN=false libffi.config ctypes-base ctypes-stubs
     make XEN=false ctypes-foreign
  '';

  installPhase =  ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
    make install XEN=false
  '';

  meta = with lib; {
    homepage = "https://github.com/ocamllabs/ocaml-ctypes";
    description = "Library for binding to C libraries using pure OCaml";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
    inherit (ocaml.meta) platforms;
  };
}
