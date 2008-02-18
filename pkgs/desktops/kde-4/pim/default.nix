args: with args;
let
rev = "774960";
in
stdenv.mkDerivation {
  name = "kdepim-r${rev}";
  
  src = fetchsvn {
    url = svn://anonsvn.kde.org/home/kde/trunk/KDE/kdepim;
    inherit rev;
    sha256 = "0596vaxzp1yh53c9q16is8j0010b8calbmd7fv3f5y8qv5w83b18";
  };

  propagatedBuildInputs = [libXinerama mesa stdenv.gcc.libc alsaLib kde4.pimlibs
  kde4.workspace libusb glib mysql libassuan libgpgerror kde4.support.qca];
  buildInputs = [cmake];
  qt4BadIncludes = true;
}
