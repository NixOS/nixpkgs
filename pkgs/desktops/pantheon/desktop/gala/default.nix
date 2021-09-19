{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, fetchpatch
, pantheon
, pkg-config
, meson
, python3
, ninja
, vala
, desktop-file-utils
, gettext
, libxml2
, gtk3
, granite
, libgee
, bamf
, libcanberra
, libcanberra-gtk3
, gnome-desktop
, mutter
, clutter
, elementary-dock
, elementary-icon-theme
, elementary-settings-daemon
, gnome-settings-daemon
, wrapGAppsHook
, gexiv2
}:

stdenv.mkDerivation rec {
  pname = "gala";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0xp9vviamzdwlcnx4836sxaz2pyfkxswgvjm73ppn7fkdm0zjpzx";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    clutter
    elementary-dock
    elementary-icon-theme
    elementary-settings-daemon
    gnome-settings-daemon
    gexiv2
    gnome-desktop
    granite
    gtk3
    libcanberra
    libcanberra-gtk3
    libgee
    mutter
  ];

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/gala/pull/1205
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/605aa10ea2a78650e001b2a247c5f7afce478b05.patch";
      sha256 = "0bg67wzrnmx8nlw93i35vhyfx8al0bj0lacgci98vwlp2m1jgbd2";
    })
    ./plugins-dir.patch
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  meta =  with lib; {
    description = "A window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = "https://github.com/elementary/gala";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
