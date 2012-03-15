{ stdenv, fetchurl, unzip, jdk, pkgconfig, gtk
, libXtst
, libXi
, mesa
, webkit
, libsoup
}:

stdenv.mkDerivation {
  name = "swt-3.7.2-201202080800";
  builder = ./builder.sh;

  # Alas, the Eclipse Project apparently doesn't produce source-only
  # releases of SWT.  So we just grab a binary release and extract
  # "src.zip" from that.
  src = fetchurl {
    url = "http://eclipse.ialto.com/eclipse/downloads/drops/R-3.7.2-201202080800/swt-3.7.2-gtk-linux-x86.zip";
    sha256 = "10si8kmc7c9qmbpzs76609wkfb784pln3qpmra73gb3fbk7z8caf";
  };

  buildInputs = [unzip jdk pkgconfig gtk libXtst libXi mesa webkit libsoup];
  inherit jdk;
}
