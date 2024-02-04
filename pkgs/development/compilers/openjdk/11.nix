{ stdenv, lib, fetchpatch, fetchFromGitHub, bash, pkg-config, autoconf, cpio, file, which, unzip
, zip, perl, cups, freetype, harfbuzz, alsa-lib, libjpeg, giflib, libpng, zlib, lcms2
, libX11, libICE, libXrender, libXext, libXt, libXtst, libXi, libXinerama
, libXcursor, libXrandr, fontconfig, openjdk11-bootstrap
, setJavaClassPath
, headless ? false
, enableJavaFX ? false, openjfx
, enableGnome2 ? true, gtk3, gnome_vfs, glib, GConf
}:

let
  major = "11";
  minor = "0";
  update = "23";
  build = "9";

  # when building a headless jdk, also bootstrap it with a headless jdk
  openjdk-bootstrap = openjdk11-bootstrap.override { gtkSupport = !headless; };

  openjdk = stdenv.mkDerivation rec {
    pname = "openjdk" + lib.optionalString headless "-headless";
    version = "${major}.${minor}.${update}+${build}";

    src = fetchFromGitHub {
      owner = "openjdk";
      repo = "jdk${major}u";
      rev = "jdk-${version}";
      sha256 = "sha256-6y6wge8ZuSKBpb5QNihvAlD4Pv/0d3AQCPOkxUm/sJk=";
    };

    nativeBuildInputs = [ pkg-config autoconf unzip ];
    buildInputs = [
      cpio file which zip perl zlib cups freetype harfbuzz alsa-lib libjpeg giflib
      libpng zlib lcms2 libX11 libICE libXrender libXext libXtst libXt libXtst
      libXi libXinerama libXcursor libXrandr fontconfig openjdk-bootstrap
    ] ++ lib.optionals (!headless && enableGnome2) [
      gtk3 gnome_vfs GConf glib
    ];

    patches = [
      ./fix-java-home-jdk10.patch
      ./read-truststore-from-env-jdk10.patch
      ./currency-date-range-jdk10.patch
      ./increase-javadoc-heap.patch
      ./fix-library-path-jdk11.patch

      # Fix build for gnumake-4.4.1:
      #   https://github.com/openjdk/jdk/pull/12992
      (fetchpatch {
        name = "gnumake-4.4.1";
        url = "https://github.com/openjdk/jdk/commit/9341d135b855cc208d48e47d30cd90aafa354c36.patch";
        hash = "sha256-Qcm3ZmGCOYLZcskNjj7DYR85R4v07vYvvavrVOYL8vg=";
      })
    ] ++ lib.optionals (!headless && enableGnome2) [
      ./swing-use-gtk-jdk10.patch
    ];

    preConfigure = ''
      chmod +x configure
      substituteInPlace configure --replace /bin/bash "${bash}/bin/bash"
    '';

    configureFlags = [
      "--with-boot-jdk=${openjdk-bootstrap.home}"
      "--with-version-pre="
      "--enable-unlimited-crypto"
      "--with-native-debug-symbols=internal"
      "--with-freetype=system"
      "--with-harfbuzz=system"
      "--with-libjpeg=system"
      "--with-giflib=system"
      "--with-libpng=system"
      "--with-zlib=system"
      "--with-lcms=system"
      "--with-stdc++lib=dynamic"
      "--disable-warnings-as-errors"
    ] ++ lib.optional stdenv.isx86_64 "--with-jvm-features=zgc"
      ++ lib.optional headless "--enable-headless-only"
      ++ lib.optional (!headless && enableJavaFX) "--with-import-modules=${openjfx}";

    separateDebugInfo = true;

    # Workaround for
    # `cc1plus: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]`
    # when building jtreg
    env.NIX_CFLAGS_COMPILE = "-Wformat";

    NIX_LDFLAGS = toString (lib.optionals (!headless) [
      "-lfontconfig" "-lcups" "-lXinerama" "-lXrandr" "-lmagic"
    ] ++ lib.optionals (!headless && enableGnome2) [
      "-lgtk-3" "-lgio-2.0" "-lgnomevfs-2" "-lgconf-2"
    ]);

    # -j flag is explicitly rejected by the build system:
    #     Error: 'make -jN' is not supported, use 'make JOBS=N'
    # Note: it does not make build sequential. Build system
    # still runs in parallel.
    enableParallelBuilding = false;

    buildFlags = [ "all" ];

    installPhase = ''
      mkdir -p $out/lib

      mv build/*/images/jdk $out/lib/openjdk

      # Remove some broken manpages.
      rm -rf $out/lib/openjdk/man/ja*

      # Mirror some stuff in top-level.
      mkdir -p $out/share
      ln -s $out/lib/openjdk/include $out/include
      ln -s $out/lib/openjdk/man $out/share/man
      ln -s $out/lib/openjdk/lib/src.zip $out/lib/src.zip

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/linux/*_md.h $out/include/

      # Remove crap from the installation.
      rm -rf $out/lib/openjdk/demo
      ${lib.optionalString headless ''
        rm $out/lib/openjdk/lib/{libjsound,libfontmanager}.so
      ''}

      ln -s $out/lib/openjdk/bin $out/bin
    '';

    preFixup = ''
      # Propagate the setJavaClassPath setup hook so that any package
      # that depends on the JDK has $CLASSPATH set up properly.
      mkdir -p $out/nix-support
      #TODO or printWords?  cf https://github.com/NixOS/nixpkgs/pull/27427#issuecomment-317293040
      echo -n "${setJavaClassPath}" > $out/nix-support/propagated-build-inputs

      # Set JAVA_HOME automatically.
      mkdir -p $out/nix-support
      cat <<EOF > $out/nix-support/setup-hook
      if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out/lib/openjdk; fi
      EOF
    '';

    postFixup = ''
      # Build the set of output library directories to rpath against
      LIBDIRS=""
      for output in $(getAllOutputNames); do
        if [ "$output" = debug ]; then continue; fi
        LIBDIRS="$(find $(eval echo \$$output) -name \*.so\* -exec dirname {} \+ | sort | uniq | tr '\n' ':'):$LIBDIRS"
      done
      # Add the local library paths to remove dependencies on the bootstrap
      for output in $(getAllOutputNames); do
        if [ "$output" = debug ]; then continue; fi
        OUTPUTDIR=$(eval echo \$$output)
        BINLIBS=$(find $OUTPUTDIR/bin/ -type f; find $OUTPUTDIR -name \*.so\*)
        echo "$BINLIBS" | while read i; do
          patchelf --set-rpath "$LIBDIRS:$(patchelf --print-rpath "$i")" "$i" || true
          patchelf --shrink-rpath "$i" || true
        done
      done
    '';

    disallowedReferences = [ openjdk-bootstrap ];

    meta = import ./meta.nix lib version;

    passthru = {
      architecture = "";
      home = "${openjdk}/lib/openjdk";
      inherit gtk3;
    };
  };
in openjdk
