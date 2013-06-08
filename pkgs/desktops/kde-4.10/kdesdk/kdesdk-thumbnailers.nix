{ kde, kdelibs, gettext }:

kde {

  buildInputs = [ kdelibs gettext ];

  patches = [ ./thumbnailers-add-subdirectory.patch ];

  meta = {
    description = "PO file format thumbnailer";
  };
}
