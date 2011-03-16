{ stdenv, fetchurl, unzip, jdk, pkgconfig, gtk
, libXtst
, libXi
, mesa
}:

stdenv.mkDerivation {
  name = "swt-3.6.1";
  builder = ./builder.sh;

  # Alas, the Eclipse Project apparently doesn't produce source-only
  # releases of SWT.  So we just grab a binary release and extract
  # "src.zip" from that.
  src = fetchurl {
    url = http://eclipse.ialto.com/eclipse/downloads/drops/R-3.6.1-201009090800/swt-3.6.1-gtk-linux-x86.zip;
    sha1 = "e629e0b65296b67931f1fce8ab72419818c9747f";
  };

  buildInputs = [unzip jdk pkgconfig gtk libXtst libXi mesa];
  inherit jdk;
}
