{ stdenv, fetchurl, unzip, jdk, pkgconfig, gtk
, libXtst, libXi, mesa, webkit, libsoup, xorg
, pango, gdk_pixbuf, glib
}:

let
  platformMap = {
    "x86_64-linux" =
      { platform = "gtk-linux-x86_64";
        sha256 = "0hq48zfqx2p0fqr0rlabnz2pdj0874k19918a4dbj0fhzkhrh959"; };
    "i686-linux" =
      { platform = "gtk-linux-x86";
        sha256 = "10si8kmc7c9qmbpzs76609wkfb784pln3qpmra73gb3fbk7z8caf"; };
    "x86_64-darwin" =
      { platform = "cocoa-macosx-x86_64";
        sha256 = "1565gg63ssrl04fh355vf9mnmq8qwwki3zpc3ybm7bylgkfwc9h4"; };
  };

  metadata = assert platformMap ? ${stdenv.system}; platformMap.${stdenv.system};

in stdenv.mkDerivation rec {
  version = "3.7.2";
  fullVersion = "${version}-201202080800";
  name = "swt-${version}";

  hardeningDisable = [ "format" ];

  # Alas, the Eclipse Project apparently doesn't produce source-only
  # releases of SWT.  So we just grab a binary release and extract
  # "src.zip" from that.
  src = fetchurl {
    url = "http://archive.eclipse.org/eclipse/downloads/drops/R-${fullVersion}/${name}-${metadata.platform}.zip";
    sha256 = metadata.sha256;
  };

  sourceRoot = ".";

  buildInputs = [ unzip jdk pkgconfig gtk libXtst libXi mesa webkit libsoup ];

  NIX_LFLAGS = [ "-lX11" "-I${xorg.libX11}/lib"
    "-lpango-1.0" "-I${pango}/lib"
    "-lgdk_pixbuf-2.0" "-I${gdk_pixbuf}/lib"
    "-lglib-2.0" "-I${glib}/lib"];

  buildPhase = ''
    unzip src.zip -d src

    cd src
    sed -i "s#^LFLAGS =#LFLAGS = $NIX_LFLAGS #g"  *.mak
    export JAVA_HOME=${jdk}

    sh ./build.sh

    mkdir out
    javac -d out/ $(find org/ -name "*.java")
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp *.so $out/lib

    mkdir -p $out/jars
    cp version.txt out/
    cd out && jar -c * > $out/jars/swt.jar
  '';

  meta = with stdenv.lib; {
    homepage = http://www.eclipse.org/swt/;
    description = "An widget toolkit for Java to access the user-interface facilities of the operating systems on which it is implemented";
    license = licenses.epl10;
    maintainers = with maintainers; [ pSub ];
  };
}
