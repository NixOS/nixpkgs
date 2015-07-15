{stdenv, xenserver-buildroot, fetchurl, libffi, ocaml, ctypes, findlib}:

stdenv.mkDerivation {
  name = "ocaml-opasswd-0.9.3";
  version = "0.9.3";

  src = fetchurl {
    url = "https://github.com/xapi-project/ocaml-opasswd/archive/0.9.3/ocaml-opasswd-0.9.3.tar.gz";
    sha256 = "1g1dz52qr1bcgcpyd4lhyd1lsxripm4bkhi5mbjvlsyc7l696lqm";
  };

  patches = [ "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-opasswd-ocaml-4.00.1.patch" ];

  buildInputs = [ libffi ocaml findlib ];

  propagatedBuildInputs = [ ctypes ];

  configurePhase = ''
    ocaml setup.ml -configure --destdir $out --prefix $out
  '';

  buildPhase = ''
    ocaml setup.ml -build
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export DESTDIR=$OCAMLFIND_DESTDIR
    ocaml setup.ml -install
    rm -f $out/usr/local/bin/opasswd_test
    '';

  meta = {
    homepage = https://github.com/xapi-project/ocaml-opasswd;
    description = "OCaml interface to the glibc passwd/shadow password functions";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
