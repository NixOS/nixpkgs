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
  version = "4.20.1";

  sha256 = "sha256-p4lAFNvCakqrsDa2FP0xbc/khx6eYqAlHwWkk8yEB7Y=";

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
