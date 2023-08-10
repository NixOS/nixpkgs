{ lib, stdenv
, fetchurl
, cairo
, meson
, ninja
, pkg-config
, python3
, asciidoc
, wrapGAppsHook
, glib
, libepoxy
, libdrm
, nv-codec-headers-11
, pipewire
, systemd
, libsecret
, libnotify
, libxkbcommon
, gdk-pixbuf
, freerdp
, fdk_aac
, tpm2-tss
, fuse3
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gnome-remote-desktop";
  version = "45.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-69YoA6URAU9WOCofS2VUTbwpTv6A2BxEjlxfRSnHtvw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    asciidoc
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    freerdp
    fdk_aac
    tpm2-tss
    fuse3
    gdk-pixbuf # For libnotify
    glib
    libepoxy
    libdrm
    nv-codec-headers-11
    libnotify
    libsecret
    libxkbcommon
    pipewire
    systemd
  ];

  mesonFlags = [
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
    "-Dtests=false" # Too deep of a rabbit hole.
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/Mutter/RemoteDesktop";
    description = "GNOME Remote Desktop server";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
