{ stdenv
, rustPlatform
, gettext
, meson
, ninja
, fetchFromGitLab
, pkg-config
, gtk3
, glib
, gdk-pixbuf
, desktop-file-utils
, appstream-glib
, wrapGAppsHook
, python3
, gnome3
, config
}:

rustPlatform.buildRustPackage rec {
  pname = "gnome-tour";
  version = "0.0.1";

  # We don't use the uploaded tar.xz because it comes pre-vendored
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-tour";
    rev = version;
    sha256 = "0lbkspnlziq3z177071w3jpghmdwflzra1krdwchzmkfmrhy50ch";
  };

  cargoSha256 = "0k1wp9wswr57fv2d9bysxn97fchd4vz29n5r8gfyp0gcm8rclmij";

  mesonFlags = [
    "-Ddistro_name=NixOS"
    "-Ddistro_icon_name=nix-snowflake"
    "-Ddistro_version=20.09"
  ];

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gtk3
  ];

  # Don't use buildRustPackage phases, only use it for rust deps setup
  configurePhase = null;
  buildPhase = null;
  checkPhase = null;
  installPhase = null;

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  # passthru = {
  #   updateScript = gnome3.updateScript {
  #     packageName = pname;
  #   };
  # };

  meta = with stdenv.lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-tour";
    description = "GNOME Greeter & Tour";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
