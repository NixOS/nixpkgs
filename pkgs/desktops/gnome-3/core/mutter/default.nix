{ fetchurl, fetchpatch, substituteAll, stdenv, pkgconfig, gnome3, gettext, gobject-introspection, upower, cairo
, pango, cogl, clutter, libstartup_notification, zenity, libcanberra-gtk3
, ninja, xkeyboard_config, libxkbfile, libxkbcommon, libXtst, libinput
, gsettings-desktop-schemas, glib, gtk3, gnome-desktop
, geocode-glib, pipewire, libgudev, libwacom, xwayland, meson
, gnome-settings-daemon
, xorgserver
, python3
, wrapGAppsHook
, sysprof
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "mutter";
  version = "3.34.0";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0qdpw0fya8kr5737jf635455qb714wvhszkk82rlw48fqj8nk8ss";
  };

  mesonFlags = [
    "-Dxwayland-path=${xwayland}/bin/Xwayland"
    "-Dinstalled_tests=false" # TODO: enable these
  ];

  propagatedBuildInputs = [
    # required for pkgconfig to detect mutter-clutter
    libXtst
  ];

  nativeBuildInputs = [
    meson
    pkgconfig
    gettext
    ninja
    python3
    # for cvt command
    xorgserver
    wrapGAppsHook
    desktop-file-utils
  ];

  buildInputs = [
    glib gobject-introspection gtk3 gsettings-desktop-schemas upower
    gnome-desktop cairo pango cogl clutter zenity libstartup_notification
    geocode-glib libinput libgudev libwacom
    libcanberra-gtk3 zenity xkeyboard_config libxkbfile
    libxkbcommon pipewire xwayland
    gnome-settings-daemon sysprof
  ];

  patches = [
    (fetchpatch {
      name = "ensure-emit-x11-display-opened.patch";
      url = "https://gitlab.gnome.org/GNOME/mutter/commit/850ef518795dcc20d3b9a4f661f70ff8d0ddacb2.patch";
      sha256 = "0cxdbrbcc8kfkvw7ryxjm2v1vk15jki7bawn128385r5hasabhxf";
    })
    # fix animation related crashes: https://gitlab.gnome.org/GNOME/mutter/merge_requests/805
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/commit/63a0b702c94af013b94ad3f32a8c5ba86bf6dfba.patch";
      sha256 = "13hvz3n275crvpankj1b47nds71c42nnbq1yx2xhhvk60qc72vh4";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/commit/1e637bd7e1b2a4316d1cf6da80966d43819a10df.patch";
      sha256 = "0jcx33j2sw7hva0gs0svqg69habxxmgdi0kcb07nqq2df6pb62qf";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/commit/c9c53cb55fd6e782c50f36da1e2adbf28111a660.patch";
      sha256 = "0iwjlbr8j0icigmilpghlkcyg4hll9dm0mcaj8lvi7qxrgjrmczr";
    })
    # Fix crash when pressing ctrl-super: https://gitlab.gnome.org/GNOME/mutter/issues/823
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/commit/0706e021f5bd82cf4c9b2c0d2916d272f3cba406.patch";
      sha256 = "0i4ixr419jggrd17gxxs45jnx131lnp8wkkhhygqsrpq8941sdw6";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/commit/76f2579e442d8ad0a3b8b644daab7c72a585506b.patch";
      sha256 = "0c3ls624k9f4mqrrbv8ng0slvm31l0li6ciqn04qd4yi18plnldy";
    })
    # Avoid crashing any apps on X11 when restarting: https://gitlab.gnome.org/GNOME/mutter/merge_requests/808
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/commit/f352c3d79da99e961341c1d2b5dd334dcade0271.patch";
      sha256 = "1drn8wjbkj903jxay5wxq163i9ahp558sjl2bc3fi1qs90xj6cn2";
    })
   # TODO: submit upstream
   ./0001-build-use-get_pkgconfig_variable-for-sysprof-dbusdir.patch
    (substituteAll {
      src = ./fix-paths.patch;
      inherit zenity;
    })
  ];

  postPatch = ''
    patchShebangs src/backends/native/gen-default-modes.py
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "mutter";
      attrPath = "gnome3.mutter";
    };
  };

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
  };
}
