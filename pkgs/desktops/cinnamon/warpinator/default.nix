{ stdenv
, fetchFromGitHub
, lib
, gobject-introspection
, meson
, ninja
, python3
, gtk3
, gdk-pixbuf
, xapp
, wrapGAppsHook
, gettext
, polkit
, glib
, gitUpdater
, bubblewrap
}:

let
  pythonEnv = python3.withPackages (pp: with pp; [
    grpcio-tools
    protobuf
    pygobject3
    setproctitle
    pp.xapp
    zeroconf
    grpcio
    setuptools
    cryptography
    pynacl
    netifaces
  ]);
in
stdenv.mkDerivation rec {
  pname = "warpinator";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-H8bFSgx3IysHCoKrMZ9gbwRl9forEjY90a/PIC68E6k=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection
    wrapGAppsHook
    gettext
    polkit # for its gettext
  ];

  buildInputs = [
    glib
    gtk3
    gdk-pixbuf
    pythonEnv
    xapp
  ];

  mesonFlags = [
    "-Dbundle-zeroconf=false"
  ];

  postPatch = ''
    chmod +x install-scripts/*
    patchShebangs .

    find . -type f -exec sed -i \
      -e s,/usr/libexec/warpinator,$out/libexec/warpinator,g \
      {} +

    # We make bubblewrap mode always available since
    # landlock mode is not supported in old kernels.
    substituteInPlace src/warpinator-launch.py \
      --replace '"/bin/python3"' '"${pythonEnv.interpreter}"' \
      --replace "/bin/bwrap" "${bubblewrap}/bin/bwrap" \
      --replace 'GLib.find_program_in_path("bwrap")' "True"

    # Typo fix that can be removed on next update
    # https://github.com/linuxmint/warpinator/pull/174
    substituteInPlace src/remote.py \
      --replace "receiver.remaining_count" "op.remaining_count"
  '';

  passthru.updateScript = gitUpdater {
    ignoredVersions = "^master.*";
  };

  meta = with lib; {
    homepage = "https://github.com/linuxmint/warpinator";
    description = "Share files across the LAN";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
