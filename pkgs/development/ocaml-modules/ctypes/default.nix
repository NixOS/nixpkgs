{ stdenv, buildOcaml, fetchzip, libffi, pkgconfig, ncurses, integers }:

buildOcaml rec {
  name = "ctypes";
  version = "0.13.1";

  minimumSupportedOcamlVersion = "4";

  src = fetchzip {
    url = "https://github.com/ocamllabs/ocaml-ctypes/archive/67e711ec891e087fbe1e0b4665aa525af4eaa409.tar.gz";
    sha256 = "1z84s5znr3lj84rzv6m37xxj9h7fwx4qiiykx3djf52qgk1rb2xb";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses ];
  propagatedBuildInputs = [ integers libffi ];

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
