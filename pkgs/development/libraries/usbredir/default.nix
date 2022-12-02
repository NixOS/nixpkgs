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
  version = "0.12.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "spice";
    repo = "usbredir";
    rev = "${pname}-${version}";
    sha256 = "sha256-OVLc3FWLBjWJnqIhhe6k+pl/HsJGzqD6xp/fXXEgRwY=";
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
