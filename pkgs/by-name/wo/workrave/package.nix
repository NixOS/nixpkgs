{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook3,
  autoconf,
  autoconf-archive,
  automake,
  gettext,
  intltool,
  libtool,
  pkg-config,
  libice,
  libsm,
  libxscrnsaver,
  libxtst,
  gobject-introspection,
  glib,
  glibmm,
  gtkmm3,
  atk,
  pango,
  pangomm,
  cairo,
  cairomm,
  dbus,
  dbus-glib,
  gst_all_1,
  libsigcxx,
  boost,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "workrave";
  version = "1.10.54";

  src = fetchFromGitHub {
    repo = "workrave";
    owner = "rcaelers";
    rev = "v" + lib.concatStringsSep "_" (lib.splitVersion finalAttrs.version);
    sha256 = "sha256-pbMkzwxgKc4vjFhBeOf513hFytYiTPST19L8Nq4CVTg=";
  };

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    gettext
    intltool
    libtool
    pkg-config
    wrapGAppsHook3
    python3Packages.jinja2
    gobject-introspection
  ];

  buildInputs = [
    libice
    libsm
    libxscrnsaver
    libxtst
    glib
    glibmm
    gtkmm3
    atk
    pango
    pangomm
    cairo
    cairomm
    dbus
    dbus-glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    libsigcxx
    boost
  ];

  preConfigure = "./autogen.sh";

  enableParallelBuilding = true;

  meta = {
    description = "Program to help prevent Repetitive Strain Injury";
    mainProgram = "workrave";
    longDescription = ''
      Workrave is a program that assists in the recovery and prevention of
      Repetitive Strain Injury (RSI). The program frequently alerts you to
      take micro-pauses, rest breaks and restricts you to your daily limit.
    '';
    homepage = "http://www.workrave.org/";
    downloadPage = "https://github.com/rcaelers/workrave/releases";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ prikhi ];
    platforms = lib.platforms.linux;
  };
})
