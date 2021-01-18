{ lib, stdenv, fetchzip, ocaml, findlib, libffi, pkgconfig, ncurses, integers }:

if !lib.versionAtLeast ocaml.version "4.02"
then throw "ctypes is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ctypes-${version}";
  version = "0.17.1";

  src = fetchzip {
    url = "https://github.com/ocamllabs/ocaml-ctypes/archive/${version}.tar.gz";
    sha256 = "16brmdnz7wi2z25qqhd5s5blyq4app6jbv6g9pa4vyg6h0nzbcys";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ocaml findlib ncurses ];
  propagatedBuildInputs = [ integers libffi ];

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
