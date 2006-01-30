{stdenv, fetchurl, unzip, jdk, pkgconfig, gtk, libXtst}:

stdenv.mkDerivation {
  name = "swt-3.1.1";
  builder = ./builder.sh;
  
  # Alas, the Eclipse Project apparently doesn't produce source-only
  # releases of SWT.  So we just grab a binary release and extract
  # "src.zip" from that.
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/swt-3.1.1-gtk-linux-x86.zip;
    md5 = "23dfe5a4a566439c5f526d9ea3b3db1c";
  };
  
  buildInputs = [unzip jdk pkgconfig gtk libXtst];
}
