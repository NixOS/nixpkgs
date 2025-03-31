{
  lib,
  mkXfceDerivation,
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
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
