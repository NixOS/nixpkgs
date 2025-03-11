{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  meson,
  ninja,
  glib,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "usbredir";
  version = "0.15.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "spice";
    repo = "usbredir";
    rev = "${pname}-${version}";
    sha256 = "sha256-a+RaJO70jxsrVwSG+PzDg2luvBHqBdNdRdLOGhdhjzY=";
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

  outputs = [
    "out"
    "dev"
  ];

  meta = with lib; {
    description = "USB traffic redirection protocol";
    mainProgram = "usbredirect";
    homepage = "https://www.spice-space.org/usbredir.html";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
