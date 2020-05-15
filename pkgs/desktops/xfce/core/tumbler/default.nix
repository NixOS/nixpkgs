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
  version = "0.2.8";

  sha256 = "1y9sphaz3izal96v53lps692xxzp5pad1d09kxsmmpm7pic4n1r2";

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
