{stdenv, fetchurl, lib, cmake}:

stdenv.mkDerivation {
  name = "oxygen-icons-4.4.4";
  src = fetchurl {
    url = mirror://kde/stable/4.4.4/src/oxygen-icons-4.4.4.tar.bz2;
    sha256 = "103001rxixpm4gb0bwdqvm9j1ygfjm25r11gz73hvyqss2v22zh4";
  };
  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
