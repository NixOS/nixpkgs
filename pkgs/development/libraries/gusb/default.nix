{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, meson
, ninja
, pkg-config
, gobject-introspection
, gi-docgen
, python3
, glib
, libusb1
, json-glib
, vala
, hwdata
, umockdev
}:

let
  pythonEnv = python3.pythonForBuild.withPackages (ps: with ps; [
    setuptools
  ]);
in
stdenv.mkDerivation rec {
  pname = "gusb";
  version = "0.4.6";

  outputs = [ "bin" "out" "dev" ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libgusb";
    rev = "refs/tags/${version}";
    hash = "sha256-CtB9+5dDs+l05NyIFkKJpS1x3zHSykhLW3HiIM0RUWY=";
  };

  patches = [
    (substituteAll {
      src = ./fix-python-path.patch;
      python = "${pythonEnv}/bin/python3";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    gi-docgen
    vala
  ];

  # all required in gusb.pc
  propagatedBuildInputs = [
    glib
    libusb1
    json-glib
  ];

  mesonFlags = [
    (lib.mesonBool "tests" doCheck)
    (lib.mesonOption "usb_ids" "${hwdata}/share/hwdata/usb.ids")
  ];

  checkInputs = [
    umockdev
  ];

  doCheck = false; # tests try to access USB

  meta = with lib; {
    description = "GLib libusb wrapper";
    homepage = "https://github.com/hughsie/libgusb";
    license = licenses.lgpl21;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.unix;
  };
}
