{ mkDerivation, extra-cmake-modules, gtk3, qtsvg, hicolor-icon-theme }:

mkDerivation {
  pname = "breeze-icons";
  nativeBuildInputs = [ extra-cmake-modules gtk3 ];
  buildInputs = [ qtsvg ];
  propagatedBuildInputs = [
    hicolor-icon-theme
  ];
  dontDropIconThemeCache = true;
  outputs = [ "out" ]; # only runtime outputs
  postInstall = ''
    gtk-update-icon-cache "''${out:?}/share/icons/breeze"
    gtk-update-icon-cache "''${out:?}/share/icons/breeze-dark"
  '';
}
