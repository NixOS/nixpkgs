{ kde, kdelibs, gettext }:

kde {

  buildInputs = [ kdelibs gettext ];

  meta = {
    description = "PO file format thumbnailer";
  };
}
