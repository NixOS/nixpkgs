{ kde, kdelibs, libvncserver, libjpeg }:

kde {
  buildInputs = [ kdelibs libvncserver libjpeg ];

  patches = [ ./kdenetwork.patch ];
}
