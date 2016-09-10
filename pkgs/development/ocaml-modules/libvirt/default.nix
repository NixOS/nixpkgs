{stdenv, xenserver-buildroot, fetchurl, gawk, libvirt, ocaml, perl, findlib}:

stdenv.mkDerivation {
  name = "ocaml-libvirt-0.6.1.2";
  version = "0.6.1.2";

  src = fetchurl {
    url = "http://libvirt.org/sources/ocaml/ocaml-libvirt-0.6.1.2.tar.gz";
    sha256 = "10jwi9b917p0j05x55s7qi00pzddyfcdpbhlz81bzwsl5hksbkik";
  };

  patches = [
      "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-libvirt-1-252568550f9bf28b07f4e6d116485205e58afe4a"
      "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-libvirt-2-c6c9c3fff5993056e0af7219f4fe67ab8db3cdf2"
      "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-libvirt-3-34a472800ba1908e910318cc5d5ed9588174c1cf"
      "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-libvirt-4-9d178cbfeb709d2d2fbddb9fcab88e9204c8f995"
      "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-libvirt-5-2360cd228542c6a523f10daacbd631a753d17208"
      "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-libvirt-6-7568d6f77d72a77c527cc282511f7a3f37dc7040"
      "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-libvirt-7-71f683ad53e11c1f0cbc5c250d29647ad5ea0bf3"
      "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-libvirt-8-d7e0e6112db9411b0d7aaa8cbf5ce85c27e7d52d"
      "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-libvirt-9-0ec198e7784de1a49672183c961a2498b6c85b90"
      "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-libvirt-10-0d103e429ddc7942e537a047c8a46ca7ddc58e46"
      "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-libvirt-11-658970236caa31bbef44562c521d55b9a4689f4d"
      "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-libvirt-12-31ce6b280a2d987abc484b8f8d1e6cb25a70d737"
      "${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-libvirt-13-fixbuild"
    ];

  buildInputs = [ gawk libvirt ocaml perl findlib ];

  configurePhase = ''
    CFLAGS="$RPM_OPT_FLAGS" ./configure --libdir=$out/lib --prefix=$out
    '';

  buildPhase = ''
    make all opt depend doc
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export DESTDIR=$out
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
    make install-opt
    '';

  meta = {
    homepage = http://libvirt.org/ocaml/;
    description = "OCaml binding for libvirt";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
