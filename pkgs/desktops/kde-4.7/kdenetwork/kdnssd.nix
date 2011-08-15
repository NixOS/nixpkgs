{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  patches = [ ./kdenetwork.patch ];
}
