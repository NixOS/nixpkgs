{ lib
, mkXfceDerivation
, ffmpegthumbnailer
, gdk-pixbuf
, glib
, freetype
, libgsf
, poppler
, gst_all_1
, libxfce4util
}:

# TODO: add libopenraw

mkXfceDerivation {
  category = "xfce";
  pname = "tumbler";
  version = "4.18.1";

  sha256 = "sha256-hn77W8IsvwNc9xSuDe9rXw9499olOvvJ2P7q+26HIG8=";

  buildInputs = [
    libxfce4util
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

  meta = with lib; {
    description = "A D-Bus thumbnailer service";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
