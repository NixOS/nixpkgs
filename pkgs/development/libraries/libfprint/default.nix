{ lib, stdenv
, fetchFromGitLab
, pkg-config
, meson
, python3
, ninja
, gusb
, pixman
, glib
, nss
, gobject-introspection
, coreutils
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
}:

stdenv.mkDerivation rec {
  pname = "libfprint";
  version = "1.90.7";
  outputs = [ "out" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libfprint";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-g/yczzCZEzUKV2uFl1MAPL1H/R2QJSwxgppI2ftt9QI=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    gobject-introspection
  ];

  buildInputs = [
    gusb
    pixman
    glib
    nss
  ];

  checkInputs = [
    python3
  ];

  mesonFlags = [
    "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d"
    # Include virtual drivers for fprintd tests
    "-Ddrivers=all"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs \
      tests/test-runner.sh \
      tests/unittest_inspector.py \
      tests/virtual-image.py
  '';

  meta = with lib; {
    homepage = "https://fprint.freedesktop.org/";
    description = "A library designed to make it easy to add support for consumer fingerprint readers";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
