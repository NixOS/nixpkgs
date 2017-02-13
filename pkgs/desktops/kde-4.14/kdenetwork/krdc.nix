{ kde, kdelibs, libvncserver, freerdp_legacy, telepathy_qt }:

kde {
  buildInputs = [ kdelibs libvncserver freerdp_legacy telepathy_qt ];

  meta = {
    description = "KDE remote desktop client";
  };
}
