{ mkXfceDerivation
, ffmpegthumbnailer
, gdk-pixbuf
, glib
, freetype
, libgsf
, poppler
, libjpeg
, gst_all_1
}:

# TODO: add libopenraw

mkXfceDerivation {
  category = "xfce";
  pname = "tumbler";
  version = "0.2.9";

  sha256 = "0b3mli40msv35qn67c1m9rn5bigj6ls10l08qk7fa3fwvzl49hmw";

  buildInputs = [
    ffmpegthumbnailer
    freetype
    gdk-pixbuf
    glib
    gst_all_1.gst-plugins-base
    libgsf
    poppler # technically the glib binding
  ];

  # WrapGAppsHook won't touch this binary automatically, so we wrap manually.
  postFixup = ''
    wrapProgram $out/lib/tumbler-1/tumblerd "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "A D-Bus thumbnailer service";
  };
}
