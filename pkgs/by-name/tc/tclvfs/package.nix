{
  lib,
  tcl,
  fetchzip,
}:

tcl.mkTclDerivation {
  pname = "tclvfs";
  version = "1.4-unstable-2023-11-23";

  src = fetchzip {
    url = "https://core.tcl-lang.org/tclvfs/tarball/8cdab08997fe82d8/tclvfs-8cdab08997fe82d8.tar.gz";
    hash = "sha256-DzZ4Puwscbr0KarMyEKeah7jDJy7cfKNBbBSh0boaUw=";
  };

  meta = {
    description = "Tcl extension that exposes Tcl's Virtual File System (VFS) subsystem to the script level";
    homepage = "https://core.tcl.tk/tclvfs";
    license = lib.licenses.tcltk;
    longDescription = ''
      The TclVfs project aims to provide an extension to the Tcl language which
      allows Virtual Filesystems to be built using Tcl scripts only. It is also
      a repository of such Tcl-implemented filesystems (metakit, zip, ftp, tar,
      http, webdav, namespace, url)
    '';
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
