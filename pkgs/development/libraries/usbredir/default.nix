{ lib
, stdenv
, cmake
, fetchFromGitLab
, pkg-config
, meson
, ninja
, glib
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "usbredir";
  version = "0.11.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "spice";
    repo = "usbredir";
    rev = "${pname}-${version}";
    sha256 = "1ra8vpi6wdq1fvvqzx4ny2ga0p0q1cwz72gr15nghyfp75y3d31l";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  propagatedBuildInputs = [
    libusb1
  ];

  mesonFlags = [
    "-Dgit_werror=disabled"
    "-Dtools=enabled"
    "-Dfuzzing=disabled"
  ];

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "USB traffic redirection protocol";
    homepage = "https://www.spice-space.org/usbredir.html";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
