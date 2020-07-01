{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vala
, gtk3
, glib
, granite
, libgee
, libcanberra-gtk3
, pantheon
, python3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-notifications";
  version = "unstable-2020-03-31";

  repoName = "notifications";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = "db552b0c3466ba1099c7737c353b7225ab1896cc";
    sha256 = "1fhf4zx73qka935x5afv6zqsm2l37d1mjbhrbzzzz44dqwa2vp16";
  };

  nativeBuildInputs = [
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libcanberra-gtk3
    libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "GTK notification server for Pantheon";
    homepage = "https://github.com/elementary/notifications";
    license = licenses.gpl3Plus;
    maintainers = pantheon.maintainers;
    platforms = platforms.linux;
  };
}
