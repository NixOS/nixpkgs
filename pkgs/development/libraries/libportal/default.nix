{ stdenv
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, pkgconfig
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_45
, glib
}:

stdenv.mkDerivation rec {
  pname = "libportal";
  version = "0.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "1s3g17zbbmq3m5jfs62fl94p4irln9hfhpybj7jb05z0p1939rk3";
  };

  patches = [
    # Fix build and .pc file
    # https://github.com/flatpak/libportal/pull/20
    (fetchpatch {
      url = "https://github.com/flatpak/libportal/commit/7828be4ec8f05f8de7b129a1e35b5039d8baaee3.patch";
      sha256 = "04nadcxx69mbnzljwjrzm88cgapn14x3mghpkhr8b9yrjn7yj86h";
    })
    (fetchpatch {
      url = "https://github.com/flatpak/libportal/commit/bf5de2f6fefec65f701b4ec8712b48b29a33fb71.patch";
      sha256 = "1v0b09diq49c01j5gg2bpvn5f5gfw1a5nm1l8grc4qg4z9jck1z8";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_45
  ];

  propagatedBuildInputs = [
    glib
  ];

  meta = with stdenv.lib; {
    description = "Flatpak portal library";
    homepage = "https://github.com/flatpak/libportal";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
