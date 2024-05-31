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
  pythonEnv = python3.pythonOnBuildForHost.withPackages (ps: with ps; [
    setuptools
  ]);
in
stdenv.mkDerivation rec {
  pname = "gusb";
  version = "0.4.9";

  outputs = [ "bin" "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libgusb";
    rev = "refs/tags/${version}";
    hash = "sha256-piIPNLc3deToyQaajXFvM+CKh9ni8mb0P3kb+2RoJOs=";
  };

  patches = [
    (substituteAll {
      src = ./fix-python-path.patch;
      python = "${pythonEnv}/bin/python3";
    })
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

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

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    ls -la "$out/share/doc"
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = with lib; {
    description = "GLib libusb wrapper";
    mainProgram = "gusbcmd";
    homepage = "https://github.com/hughsie/libgusb";
    license = licenses.lgpl21;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.unix;
  };
}
