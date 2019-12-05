{ stdenv, lib, fetchurl, unzip, jdk, pkgconfig, gtk2, gtk3
, libXt, libXtst, libXi, libGLU, libGL, webkitgtk, libsoup, xorg
, pango, gdk-pixbuf, glib
}:

let
  platformMap = {
    x86_64-linux = {
      platform = "gtk-linux-x86_64";
      sha256 = "12y0x9yf3bc35blr08yda1h7cc1n26a37zakszizyx8adglxlbs4";
    };
    x86_64-darwin = {
      platform = "cocoa-macosx-x86_64";
      sha256 = "1mwra5a2x9k6gqa8azwybc813ngxcjg80jncpn083xspkxmmmv47";
    };
  };

  metadata = assert platformMap ? ${stdenv.hostPlatform.system}; platformMap.${stdenv.hostPlatform.system};

in stdenv.mkDerivation rec {
  version = "4.14";
  fullVersion = "${version}-201912100610";
  pname = "swt";

  hardeningDisable = [ "format" ];

  # Alas, the Eclipse Project apparently doesn't produce source-only
  # releases of SWT.  So we just grab a binary release and extract
  # "src.zip" from that.
  src = fetchurl {
    url = "http://archive.eclipse.org/eclipse/downloads/drops4/R-${fullVersion}/${pname}-${version}-${metadata.platform}.zip";
    sha256 = metadata.sha256;
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip pkgconfig ];
  buildInputs = [ jdk gtk2 gtk3 libXt libXtst libXi libGLU libGL webkitgtk libsoup ];

  NIX_LFLAGS = (map (x: "-L${lib.getLib x}/lib") [ xorg.libX11 pango gdk-pixbuf glib ]) ++
    [ "-lX11" "-lpango-1.0" "-lgdk_pixbuf-2.0" "-lglib-2.0" ];

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
    platforms = with platforms; linux;
  };
}
