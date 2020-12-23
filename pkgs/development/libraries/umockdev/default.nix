{ stdenv, fetchurl, fetchpatch, pkgconfig
, gobject-introspection, glib, systemd, libgudev, vala
, usbutils, which, python3 }:

stdenv.mkDerivation rec {
  pname = "umockdev";
  version = "0.13.1";

  outputs = [ "bin" "out" "dev" "doc" ];

  src = fetchurl {
    url = "https://github.com/martinpitt/umockdev/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "197a169imiirgm73d9fn9234cx56agyw9d2f47h7f1d8s2d51lla";
  };

  patches = [
    ./fix-test-paths.patch
    # https://github.com/NixOS/nixpkgs/commit/9960a2be9b32a6d868046c5bfa188b9a0dd66682#commitcomment-34734461
    ./disable-failed-test.patch
    # https://github.com/martinpitt/umockdev/pull/93
    (fetchpatch {
      url = "https://github.com/abbradar/umockdev/commit/ce22f893bf50de0b32760238a3e2cfb194db89e9.patch";
      sha256 = "01q3qhs30x8hl23iigimsa2ikbiw8y8y0bpmh02mh1my87shpwnx";
    })
  ];

  # autoreconfHook complains if we try to build the documentation
  postPatch = ''
    echo 'EXTRA_DIST =' > docs/gtk-doc.make
  '';

  preCheck = ''
    patchShebangs tests/test-static-code
  '';

  buildInputs = [ glib systemd libgudev ];

  nativeBuildInputs = [ pkgconfig vala gobject-introspection ];

  checkInputs = [ python3 which usbutils ];

  enableParallelBuilding = true;

  # Test fail with libusb 1.0.24
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mock hardware devices for creating unit tests";
    license = licenses.lgpl2;
    maintainers = with maintainers; [];
    platforms = with platforms; linux;
  };
}
