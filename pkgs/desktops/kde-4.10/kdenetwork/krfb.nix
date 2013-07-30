{ kde, kdelibs, libvncserver, libXdamage, libXtst, libjpeg }:

kde {
  buildInputs = [ kdelibs libvncserver libXdamage libXtst libjpeg ];
}
