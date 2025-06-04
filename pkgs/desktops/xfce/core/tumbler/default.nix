{
  lib,
  mkXfceDerivation,
  fetchpatch,
  ffmpegthumbnailer,
  gdk-pixbuf,
  glib,
  freetype,
  libgepub,
  libgsf,
  libheif,
  libjxl,
  librsvg,
  poppler,
  gst_all_1,
  webp-pixbuf-loader,
  libxfce4util,
}:

# TODO: add libopenraw

mkXfceDerivation {
  category = "xfce";
  pname = "tumbler";
  version = "4.20.0";

  sha256 = "sha256-GmEMdG8Ikd4Tq/1ntCHiN0S7ehUXqzMX7OtXsycLd6E=";

  patches = [
    # Fixes PDF previews staying low resolution
    # https://gitlab.xfce.org/xfce/tumbler/-/merge_requests/35
    (fetchpatch {
      name = "only-use-embedded-pdf-thumbnail-if-resolution-suffices.patch";
      url = "https://gitlab.xfce.org/xfce/tumbler/-/commit/69a704e0f4e622861ce4007f6f3f4f6f6b962689.patch";
      hash = "sha256-aFJoWWzTaikqCw6C1LH+BFxst/uKkOGT1QK9Mx8/8/c=";
    })
  ];

  buildInputs = [
    libxfce4util
    ffmpegthumbnailer
    freetype
    gdk-pixbuf
    glib
    gst_all_1.gst-plugins-base
    libgepub # optional EPUB thumbnailer support
    libgsf
    poppler # technically the glib binding
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${
        lib.makeSearchPath "share" [
          libheif.out
          libjxl
          librsvg
          webp-pixbuf-loader
        ]
      }"
      # For heif-thumbnailer in heif.thumbnailer
      --prefix PATH : "${lib.makeBinPath [ libheif ]}"
    )
  '';

  # WrapGAppsHook won't touch this binary automatically, so we wrap manually.
  postFixup = ''
    wrapGApp $out/lib/tumbler-1/tumblerd
  '';

  meta = with lib; {
    description = "D-Bus thumbnailer service";
    teams = [ teams.xfce ];
  };
}
