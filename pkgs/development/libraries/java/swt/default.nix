{ lib, stdenv, fetchzip, pkgsBuildHost
, atk, gdk-pixbuf, glib, gtk2, jdk, libGL, libGLU, libXi, libXt, libXtst
, libsoup, pango, webkitgtk, xorg
}:

let
  platformMap = {
    x86_64-linux =
      { platform = "gtk-linux-x86_64";
        sha256 = "17frac2nsx22hfa72264as31rn35hfh9gfgy0n6wvc3knl5d2716"; };
    i686-linux =
      { platform = "gtk-linux-x86";
        sha256 = "13ca17rga9yvdshqvh0sfzarmdcl4wv4pid0ls7v35v4844zbc8b"; };
    x86_64-darwin =
      { platform = "cocoa-macosx-x86_64";
        sha256 = "0wjyxlw7i9zd2m8syd6k1q85fj8pzhxlfsrl8fpgsj37p698bd0a"; };
  };

  metadata = assert platformMap ? ${stdenv.hostPlatform.system};
    platformMap.${stdenv.hostPlatform.system};
in stdenv.mkDerivation rec {
  pname = "swt";
  version = "4.5";
  fullVersion = "${version}-201506032000";

  hardeningDisable = [ "format" ];

  # Alas, the Eclipse Project apparently doesn't produce source-only
  # releases of SWT.  So we just grab a binary release and extract
  # "src.zip" from that.
  src = fetchzip {
    url = "http://archive.eclipse.org/eclipse/downloads/drops4/" +
      "R-${fullVersion}/${pname}-${version}-${metadata.platform}.zip";
    sha256 = metadata.sha256;
    stripRoot = false;
    extraPostFetch = ''
      mkdir "$unpackDir"
      cd "$unpackDir"

      renamed="$TMPDIR/src.zip"
      mv "$out/src.zip" "$renamed"
      unpackFile "$renamed"
      rm -r "$out"

      mv "$unpackDir" "$out"
    '';
  };

  nativeBuildInputs = [
    pkgsBuildHost.canonicalize-jars-hook
    pkgsBuildHost.pkg-config
  ];
  buildInputs = [
    atk
    gtk2
    jdk
    libGL
    libGLU
    libXi
    libXt
    libXtst
    libsoup
    webkitgtk
  ];

  patches = [ ./awt-libs.patch ./gtk-libs.patch ];

  prePatch = ''
    # clear whitespace from makefiles (since we match on EOL later)
    sed -i 's/ \+$//' ./*.mak
  '';

  postPatch = let makefile-sed = builtins.toFile "swt-makefile.sed" (''
    # fix pkg-config invocations in CFLAGS/LIBS pairs
    /^[A-Z0-9_]\+CFLAGS = `pkg-config --cflags [^`]\+`$/ {
      N
      s'' +
        "/" + ''
          ^\([A-Z0-9_]\+\)CFLAGS = `pkg-config --cflags \(.\+\)`\
          \1LIBS = `pkg-config --libs-only-L .\+$'' +
        "/" + ''
          \1CFLAGS = `pkg-config --cflags \2`\
          \1LIBS = `pkg-config --libs \2`'' +
        "/\n" + ''
    }
    # fix WebKit libs not being there
    s/\$(WEBKIT_LIB) \$(WEBKIT_OBJECTS)$/\0 `pkg-config --libs glib-2.0`/g
  ''); in ''
    declare -a makefiles=(./*.mak)
    sed -i -f ${makefile-sed} "''${makefiles[@]}"
    sed -i -e 's/ = `\([^`]\+\)`/ := $(shell \1)/' \
      -e 's/`\([^`]\+\)`/$(shell \1)/' \
      "''${makefiles[@]}"
  '';

  buildPhase = ''
    export JAVA_HOME=${jdk}

    sh ./build.sh

    mkdir out
    find org/ -name '*.java' -type f -exec javac -d out/ {} +
  '';

  installPhase = ''
    mkdir -p "$out/lib"
    cp -t "$out/lib" ./*.so

    mkdir -p "$out/jars"
    cp -t out/ version.txt
    (cd out && jar -c *) > "$out/jars/swt.jar"
  '';

  meta = {
    homepage = "http://www.eclipse.org/swt/";
    description = ''
      An widget toolkit for Java to access the user-interface
      facilities of the operating systems on which it is implemented.
    '';
    license = lib.licenses.epl10;
    maintainers = with lib.maintainers; [ bb010g pSub ];
    platforms = lib.platforms.linux;
  };
}
