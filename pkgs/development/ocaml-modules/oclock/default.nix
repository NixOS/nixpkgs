{stdenv, xenserver-buildroot, fetchurl, which, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocaml-oclock-0.3";
  version = "0.3";

  src = fetchurl {
    url = "https://github.com/polazarus/oclock/archive/v0.3/oclock-0.3.tar.gz";
    sha256 = "1swlwwi6vs60x350h6i4dzn7z792cv2dn1gsal8x3fvnwzm7svg4";
  };

  patches = [ "${xenserver-buildroot}/usr/share/buildroot/SOURCES/oclock-1-cc-headers" "${xenserver-buildroot}/usr/share/buildroot/SOURCES/oclock-2-destdir" ];

  buildInputs = [ ocaml findlib which ];

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export OCAMLFIND_DISTDIR=$OCAMLFIND_DESTDIR
    mkdir -p $OCAMLFIND_DISTDIR/stublibs
    export OCAMLFIND_LDCONF=ignore
    make install DESTDIR=$OCAMLFIND_DESTDIR
    '';

  meta = {
    homepage = https://github.com/polazarus/oclock;
    description = "POSIX monotonic clock for OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
