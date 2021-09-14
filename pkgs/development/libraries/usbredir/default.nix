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
  version = "0.10.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "spice";
    repo = "usbredir";
    rev = "${pname}-${version}";
    sha256 = "1dz8jms9l6gg2hw0k6p1p1lnchc9mcgmskgvm5gbdvw3j7wrhdbz";
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
