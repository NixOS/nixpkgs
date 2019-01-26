{ stdenv, lib, fetchurl, unzip, jdk, pkgconfig, gtk2
, libXt, libXtst, libXi, libGLU_combined, webkit, libsoup, xorg
, pango, gdk_pixbuf, glib
}:

let
  platformMap = {
    "x86_64-linux" =
      { platform = "gtk-linux-x86_64";
        sha256 = "1qq0pjll6030v4ml0hifcaaik7sx3fl7ghybfdw95vsvxafwp2ff"; };
    "i686-linux" =
      { platform = "gtk-linux-x86";
        sha256 = "03mhzraikcs4fsz7d3h5af9pw1bbcfd6dglsvbk2ciwimy9zj30q"; };
    "x86_64-darwin" =
      { platform = "cocoa-macosx-x86_64";
        sha256 = "00k1mfbncvyh8klgmk0891w8jwnd5niqb16j1j8yacrm2smmlb05"; };
  };

  metadata = assert platformMap ? ${stdenv.hostPlatform.system}; platformMap.${stdenv.hostPlatform.system};

in stdenv.mkDerivation rec {
  version = "4.5";
  fullVersion = "${version}-201506032000";
  name = "swt-${version}";

  hardeningDisable = [ "format" ];

  # Alas, the Eclipse Project apparently doesn't produce source-only
  # releases of SWT.  So we just grab a binary release and extract
  # "src.zip" from that.
  src = fetchurl {
    url = "http://archive.eclipse.org/eclipse/downloads/drops4/R-${fullVersion}/${name}-${metadata.platform}.zip";
    sha256 = metadata.sha256;
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip pkgconfig ];
  buildInputs = [ jdk gtk2 libXt libXtst libXi libGLU_combined webkit libsoup ];

  NIX_LFLAGS = (map (x: "-L${lib.getLib x}/lib") [ xorg.libX11 pango gdk_pixbuf glib ]) ++
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
