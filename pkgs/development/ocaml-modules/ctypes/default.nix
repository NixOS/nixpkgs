{ lib, stdenv, fetchFromGitHub, ocaml, findlib, libffi, pkg-config, ncurses, integers, bigarray-compat }:

if lib.versionOlder ocaml.version "4.02"
then throw "ctypes is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-ctypes";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "ocamllabs";
    repo = "ocaml-ctypes";
    rev = version;
    sha256 = "sha256-H1QR0MJCqRdXxRufCA663wzTNWQ8MYYAy2nz/XHCn0Y=";
  };

  nativeBuildInputs = [ pkg-config ocaml findlib ];
  buildInputs = [ ncurses ];
  propagatedBuildInputs = [ integers libffi bigarray-compat ];

  strictDeps = true;

  buildPhase = ''
    make XEN=false libffi.config ctypes-base ctypes-stubs
    make XEN=false ctypes-foreign
  '';

  installPhase = ''
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
