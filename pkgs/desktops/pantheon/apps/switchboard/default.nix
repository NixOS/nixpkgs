{ stdenv
, fetchFromGitHub
, nix-update-script
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
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "12xir2gssr0x21sgm5m620bvd6b6y8dcm26cj4s1wsn8qb59jx9p";
  };

  passthru = {
    updateScript = nix-update-script {
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
    homepage = "https://github.com/elementary/switchboard";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
