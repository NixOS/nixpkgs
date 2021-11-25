{ lib
, stdenv
, canonicalize-jars-hook
, fetchzip
, pkg-config
, atk
, glib
, gtk2
, jdk
, libGL
, libGLU
, libXt
, libXtst
, gnome2
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
    url = "https://archive.eclipse.org/eclipse/downloads/drops4/" +
      "R-${fullVersion}/${pname}-${version}-${metadata.platform}.zip";
    inherit (metadata) sha256;
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
    canonicalize-jars-hook
    pkg-config
  ];
  buildInputs = [
    atk
    gtk2
    jdk
    libGL
    libGLU
    libXtst
    gnome2.gnome_vfs
    gnome2.libgnome
    gnome2.libgnomeui
  ] ++ lib.optionals (lib.hasPrefix "8u" jdk.version) [
    libXt
  ];

  patches = [ ./awt-libs.patch ./gtk-libs.patch ];

  prePatch = ''
    # clear whitespace from makefiles (since we match on EOL later)
    sed -i 's/ \+$//' ./*.mak
  '';

  postPatch = let makefile-sed = builtins.toFile "swt-makefile.sed" (''
    # fix pkg-config invocations in CFLAGS/LIBS pairs.
    #
    # change:
    #     FOOCFLAGS = `pkg-config --cflags `foo bar`
    #     FOOLIBS = `pkg-config --libs-only-L foo` -lbaz
    # into:
    #     FOOCFLAGS = `pkg-config --cflags foo bar`
    #     FOOLIBS = `pkg-config --libs foo bar`
    #
    # the latter works more consistently.
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
    # assign Makefile variables eagerly & change backticks to `$(shell …)`
    sed -i -e 's/ = `\([^`]\+\)`/ := $(shell \1)/' \
      -e 's/`\([^`]\+\)`/$(shell \1)/' \
      "''${makefiles[@]}"
  '';

  buildPhase = ''
    runHook preBuild

    export JAVA_HOME=${jdk}

    ./build.sh

    mkdir out
    find org/ -name '*.java' -type f -exec javac -d out/ {} +

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    if [ -n "$prefix" ]; then
      mkdir -p "$prefix"
    fi

    mkdir -p "$out/lib"
    cp -t "$out/lib" ./*.so

    mkdir -p "$out/jars"
    cp -t out/ version.txt
    (cd out && jar -c *) > "$out/jars/swt.jar"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.eclipse.org/swt/";
    description = ''
      A widget toolkit for Java to access the user-interface facilities of
      the operating systems on which it is implemented.
    '';
    license = licenses.epl10;
    maintainers = with maintainers; [ bb010g ];
    platforms = platforms.linux;
  };
}
