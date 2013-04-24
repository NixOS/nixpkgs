{ kde, kdelibs, gettext }:

kde {
#todo: doesn't build
  buildInputs = [ kdelibs gettext ];

  meta = {
    description = "PO file format thumbnailer";
  };
}
