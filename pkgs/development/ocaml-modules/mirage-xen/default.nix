{stdenv, xenserver-buildroot, fetchurl, which, ocaml, camlp4, cstruct, evtchn, findlib, gnt, io-page, lwt, mirage-clock-xen, mirage-types, shared-memory-ring, xenstore}:

stdenv.mkDerivation {
  name = "ocaml-mirage-xen-1.1.1";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-platform/archive/v1.1.1/ocaml-mirage-xen-1.1.1.tar.gz";
    sha256 = "09pq1akrpa1q6iznndfjwz6wrmvh9vz3p1wgdqqn6hspkhfmxc5i";
  };

  buildInputs = [ which ocaml camlp4 cstruct evtchn findlib gnt io-page lwt mirage-types ];

  propagatedBuildInputs = [ mirage-clock-xen shared-memory-ring xenstore ];

  configurePhase = ''
    cp ${xenserver-buildroot}/usr/share/buildroot/SOURCES/ocaml-mirage-xen.install.sh ocaml-mirage-xen.install.sh
    '';

  buildPhase = ''
    make xen-build
    '';

  createFindlibDestdir = true;

  installPhase = ''
    sh ./ocaml-mirage-xen.install.sh $OCAMLFIND_DESTDIR $out
    '';

  meta = {
    homepage = https://github.com/mirage/mirage-platform/;
    description = "Mirage OS library for Xen compilation";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
