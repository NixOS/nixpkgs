{ kde, kdelibs, shared_desktop_ontologies, glib, htmlTidy }:

kde {
  buildInputs = [ kdelibs shared_desktop_ontologies glib htmlTidy ];

  meta = {
    description = "Base KDE applications, including the Dolphin file manager and Konqueror web browser";
    license = "GPLv2";
  };
}
