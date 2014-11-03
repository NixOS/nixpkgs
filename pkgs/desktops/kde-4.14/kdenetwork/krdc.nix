{ kde, kdelibs, libvncserver, freerdp, telepathy_qt }:

kde {
  buildInputs = [ kdelibs libvncserver freerdp telepathy_qt ];

  meta = {
    description = "KDE remote desktop client";
  };
}
