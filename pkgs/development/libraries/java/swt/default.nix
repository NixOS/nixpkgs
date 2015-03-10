{ stdenv, fetchurl, unzip, jdk, pkgconfig, gtk
, libXtst
, libXi
, mesa
, webkit
, libsoup
}:

let metadata = if stdenv.system == "i686-linux"
               then { arch = "x86"; sha256 = "10si8kmc7c9qmbpzs76609wkfb784pln3qpmra73gb3fbk7z8caf"; }
               else if stdenv.system == "x86_64-linux"
                    then { arch = "x86_64"; sha256 = "0hq48zfqx2p0fqr0rlabnz2pdj0874k19918a4dbj0fhzkhrh959"; }
                    else { };
in stdenv.mkDerivation rec {
  version = "3.7.2";
  fullVersion = "${version}-201202080800";
  name = "swt-${version}";

  builder = ./builder.sh;

  # Alas, the Eclipse Project apparently doesn't produce source-only
  # releases of SWT.  So we just grab a binary release and extract
  # "src.zip" from that.
  src = fetchurl {
    url = "http://archive.eclipse.org/eclipse/downloads/drops/R-${fullVersion}/${name}-gtk-linux-${metadata.arch}.zip";
    sha256 = metadata.sha256;
  };

  buildInputs = [unzip jdk pkgconfig gtk libXtst libXi mesa webkit libsoup];
  inherit jdk;
}
