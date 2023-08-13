{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, pkg-config
, meson
, ninja
, exiv2
, libheif
, libjpeg
, libtiff
, gst_all_1
, libraw
, libsoup
, libsecret
, glib
, gtk3
, gsettings-desktop-schemas
, librsvg
, libwebp
, json-glib
, webkitgtk
, lcms2
, bison
, flex
, clutter-gtk
, wrapGAppsHook
, shared-mime-info
, python3
, desktop-file-utils
, itstool
, xapp
}:

stdenv.mkDerivation rec {
  pname = "pix";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "sha256-iNUhcHG4nCZ4WNELodyLdztzfNg9g+F0eQrZHXS6Zj0=";
  };

  patches = [
    # Fix build with exiv2 0.28, can be removed on next update
    # https://github.com/linuxmint/pix/pull/178
    (fetchpatch {
      url = "https://github.com/linuxmint/pix/commit/46e19703a973d51fa97e6a22121560f5ba200eea.patch";
      sha256 = "sha256-Z+pUxoy0m/agXW++YxEUhRuax0qvuGVXNhU8d9mvGh4=";
    })
  ];

  nativeBuildInputs = [
    bison
    desktop-file-utils
    flex
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    clutter-gtk
    exiv2
    glib
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gtk3
    json-glib
    lcms2
    libheif
    libjpeg
    libraw
    librsvg
    libsecret
    libsoup
    libtiff
    libwebp
    webkitgtk
    xapp
  ];

  postPatch = ''
    chmod +x pix/make-pix-h.py

    patchShebangs data/gschemas/make-enums.py \
      pix/make-pix-h.py \
      po/make-potfiles-in.py \
      postinstall.py \
      pix/make-authors-tab.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  meta = with lib; {
    description = "A generic image viewer from Linux Mint";
    homepage = "https://github.com/linuxmint/pix";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
