{ stdenv
, fetchFromGitHub
, pantheon
, pkgconfig
, meson
, python3
, ninja
, vala
, gtk3
, libgee
, granite
, gettext
, clutter-gtk
, elementary-icon-theme
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "switchboard";
  version = "2.3.8";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1y254irl07fp70228zm268w20zd7risz0sk9i9wz59yynxwjshbx";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter-gtk
    elementary-icon-theme
    granite
    gtk3
    libgee
  ];

  patches = [
    ./plugs-path-env.patch
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Extensible System Settings app for Pantheon";
    homepage = https://github.com/elementary/switchboard;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
