{ kde, kdelibs, libvncserver, libXdamage, libXtst }:

kde {
  buildInputs = [ kdelibs libvncserver libXdamage libXtst];

  patches = [ ./kdenetwork.patch ];
}
