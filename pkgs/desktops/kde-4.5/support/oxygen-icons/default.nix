{kdePackage, cmake}:

kdePackage {
  pn = "oxygen-icons";
  v = "4.5.0";
  sha256 = "11wlrxnral4q5wi46p1di1cff4vr5da35a8dv2xx3ag6lnhqvjqi";
} {
  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
  };
}
