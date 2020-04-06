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
  version = "2.3.9";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0gq2gi14ywmhhlq3vablzqjzxq2ms60l9b10splzsf3zd7k2dqz2";
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
