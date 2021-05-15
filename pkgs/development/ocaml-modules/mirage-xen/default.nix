{ lib
, buildDunePackage
, fetchurl
, pkg-config
, cstruct
, lwt
, shared-memory-ring-lwt
, xenstore
, lwt-dllist
, mirage-profile
, mirage-runtime
, logs
, fmt
, ocaml-freestanding
, bheap
, duration
, io-page
}:

buildDunePackage rec {
  pname = "mirage-xen";
  version = "6.0.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-xen/releases/download/v${version}/mirage-xen-v${version}.tbz";
    sha256 = "f991e972059b27993c287ad010d9281fee061efaa1dd475d0955179f93710fbd";
  };

  patches = [
    ./makefile-no-opam.patch
    ./pkg-config.patch
  ];

  # can't handle OCAMLFIND_DESTDIR with substituteAll
  postPatch = ''
    substituteInPlace lib/bindings/mirage-xen.pc \
      --replace "@out@" "$out" \
      --replace "@OCAMLFIND_DESTDIR@" "$OCAMLFIND_DESTDIR"
  '';

  minimumOCamlVersion = "4.08";

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    cstruct
    lwt
    shared-memory-ring-lwt
    xenstore
    lwt-dllist
    mirage-profile
    mirage-runtime
    io-page
    logs
    fmt
    bheap
    duration
    (ocaml-freestanding.override { target = "xen"; })
  ];

  # Move pkg-config files into their well-known location.
  # This saves us an extra setup hook and causes no issues
  # since we patch all relative paths out of the .pc file.
  postInstall = ''
    mv $OCAMLFIND_DESTDIR/pkgconfig $out/lib/pkgconfig
  '';

  meta = with lib; {
    description = "Xen core platform libraries for MirageOS";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    homepage = "https://github.com/mirage/mirage-xen";
  };
}
