{
  stdenv,
  fetchFromGitHub,
  lib,
  gobject-introspection,
  meson,
  ninja,
  python3,
  gtk3,
  gdk-pixbuf,
  xapp,
  wrapGAppsHook3,
  gettext,
  polkit,
  glib,
  gitUpdater,
  bubblewrap,
}:

let
  pythonEnv = python3.withPackages (
    pp: with pp; [
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
      netaddr
      ifaddr
      qrcode
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "warpinator";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-qtz8/vO6LJ19NcuFf9p3DWNy41kkoBWlgZGChlnTOvI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection
    wrapGAppsHook3
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
    "-Dbundle-grpc=false"
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
