{ kde, kdelibs, libvncserver, libXdamage, libXtst, libjpeg, telepathy_qt }:

kde {
  buildInputs = [ kdelibs libvncserver libXdamage libXtst libjpeg telepathy_qt ];

  meta = {
    description = "KDE desktop sharing";
  };
}
