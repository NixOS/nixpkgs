{ kde, kdelibs, htmlTidy, kactivities
, baloo, baloo_widgets, libXt }:

kde {
  buildInputs = [ kdelibs baloo baloo_widgets htmlTidy kactivities libXt ];

  meta = {
    description = "Base KDE applications, including the Dolphin file manager and Konqueror web browser";
    license = "GPLv2";
  };
}
