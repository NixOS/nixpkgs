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
  version = "4.18.0";

  sha256 = "sha256-qxbS0PMhwVk2I3fbblJEeIuI72xSWVsQx5SslhOvg+c=";

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
