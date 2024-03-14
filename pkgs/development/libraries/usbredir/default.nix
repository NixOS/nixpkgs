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
  version = "0.14.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "spice";
    repo = "usbredir";
    rev = "${pname}-${version}";
    sha256 = "sha256-ShxysMoFSGP/dSIPthwb1Q6htotv7BP9jm09p2Nqdus=";
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
    platforms = platforms.unix;
  };
}
