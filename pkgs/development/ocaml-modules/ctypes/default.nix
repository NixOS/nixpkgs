{stdenv, buildOcaml, fetchurl, libffi, pkgconfig, ncurses}:

buildOcaml rec {
  name = "ctypes";
  version = "0.4.1";

  minimumSupportedOcamlVersion = "4";

  src = fetchurl {
    url = "https://github.com/ocamllabs/ocaml-ctypes/archive/${version}.tar.gz";
    sha256 = "74564e049de5d3c0e76ea284c225cb658ac1a2b483345be1efb9be4b3c1702f5";
  };

  buildInputs = [ ncurses pkgconfig ];
  propagatedBuildInputs = [ libffi ];

  hasSharedObjects = true;

  buildPhase =  ''
     make XEN=false libffi.config ctypes-base ctypes-stubs
     make XEN=false ctypes-foreign
  '';

  installPhase =  ''
    make install XEN=false
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ocamllabs/ocaml-ctypes;
    description = "Library for binding to C libraries using pure OCaml";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
