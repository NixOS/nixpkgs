{ kde, kdelibs, libvncserver }:

kde {
  buildInputs = [ kdelibs libvncserver ];

  patches = [ ./kdenetwork.patch ];
}
