{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, meson
, ninja
, exiv2
, libheif
, libjpeg
, libtiff
, gst_all_1
, libraw
, libsecret
, glib
, gtk3
, gsettings-desktop-schemas
, librsvg
, libwebp
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
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "sha256-tRndJjUw/k5mJPFTBMfW88Mvp2wZtC3RUzyS8bBO1jc=";
  };

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
    lcms2
    libheif
    libjpeg
    libraw
    librsvg
    libsecret
    libtiff
    libwebp
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

  # Avoid direct dependency on webkit2gtk-4.0
  # https://fedoraproject.org/wiki/Changes/Remove_webkit2gtk-4.0_API_Version
  mesonFlags = [ "-Dwebservices=false" ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  meta = with lib; {
    description = "A generic image viewer from Linux Mint";
    mainProgram = "pix";
    homepage = "https://github.com/linuxmint/pix";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
