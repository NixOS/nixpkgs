{ kde, kdelibs, libvncserver, libjpeg }:

kde {
#todo: doesn't build
  buildInputs = [ kdelibs libvncserver libjpeg ];

  patches = [ ./kdenetwork.patch ];
}
