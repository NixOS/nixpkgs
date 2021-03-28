{ stdenv, lib, fetchFromGitHub, bash, pkg-config, autoconf, cpio, file, which, unzip
, zip, perl, cups, freetype, alsaLib, libjpeg, giflib, libpng, zlib, lcms2
, libX11, libICE, libXrender, libXext, libXt, libXtst, libXi, libXinerama
, libXcursor, libXrandr, fontconfig, openjdk11-bootstrap
, setJavaClassPath
, headless ? false
, enableJavaFX ? openjfx.meta.available, openjfx
, enableGnome2 ? true, gtk3, gnome_vfs, glib, GConf
}:

let
  major = "11";
  minor = "0";
  update = "10";
  build = "9";

  openjdk = stdenv.mkDerivation rec {
    pname = "openjdk" + lib.optionalString headless "-headless";
    version = "${major}.${minor}.${update}+${build}";

    src = fetchFromGitHub {
      owner = "openjdk";
      repo = "jdk${major}u";
      rev = "jdk-${version}";
      sha256 = "06pm3hpz4ggiqwvkgzxr39y9kga7vk4flakfznz5979bvgb926vw";
    };

    nativeBuildInputs = [ pkg-config autoconf unzip ];
    buildInputs = [
      cpio file which zip perl zlib cups freetype alsaLib libjpeg giflib
      libpng zlib lcms2 libX11 libICE libXrender libXext libXtst libXt libXtst
      libXi libXinerama libXcursor libXrandr fontconfig openjdk11-bootstrap
    ] ++ lib.optionals (!headless && enableGnome2) [
      gtk3 gnome_vfs GConf glib
    ];

    patches = [
      ./fix-java-home-jdk10.patch
      ./read-truststore-from-env-jdk10.patch
      ./currency-date-range-jdk10.patch
      ./increase-javadoc-heap.patch
    ] ++ lib.optionals (!headless && enableGnome2) [
      ./swing-use-gtk-jdk10.patch
    ];

    preConfigure = ''
      chmod +x configure
      substituteInPlace configure --replace /bin/bash "${bash}/bin/bash"
    '';

    configureFlags = [
      "--with-boot-jdk=${openjdk11-bootstrap.home}"
      "--with-version-pre="
      "--enable-unlimited-crypto"
      "--with-native-debug-symbols=internal"
      "--with-libjpeg=system"
      "--with-giflib=system"
      "--with-libpng=system"
      "--with-zlib=system"
      "--with-lcms=system"
      "--with-stdc++lib=dynamic"
    ] ++ lib.optional stdenv.isx86_64 "--with-jvm-features=zgc"
      ++ lib.optional headless "--enable-headless-only"
      ++ lib.optional (!headless && enableJavaFX) "--with-import-modules=${openjfx}";

    separateDebugInfo = true;

    NIX_CFLAGS_COMPILE = "-Wno-error";

    NIX_LDFLAGS = toString (lib.optionals (!headless) [
      "-lfontconfig" "-lcups" "-lXinerama" "-lXrandr" "-lmagic"
    ] ++ lib.optionals (!headless && enableGnome2) [
      "-lgtk-3" "-lgio-2.0" "-lgnomevfs-2" "-lgconf-2"
    ]);

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
      for output in $outputs; do
        if [ "$output" = debug ]; then continue; fi
        LIBDIRS="$(find $(eval echo \$$output) -name \*.so\* -exec dirname {} \+ | sort | uniq | tr '\n' ':'):$LIBDIRS"
      done
      # Add the local library paths to remove dependencies on the bootstrap
      for output in $outputs; do
        if [ "$output" = debug ]; then continue; fi
        OUTPUTDIR=$(eval echo \$$output)
        BINLIBS=$(find $OUTPUTDIR/bin/ -type f; find $OUTPUTDIR -name \*.so\*)
        echo "$BINLIBS" | while read i; do
          patchelf --set-rpath "$LIBDIRS:$(patchelf --print-rpath "$i")" "$i" || true
          patchelf --shrink-rpath "$i" || true
        done
      done
    '';

    disallowedReferences = [ openjdk11-bootstrap ];

    meta = with lib; {
      homepage = "http://openjdk.java.net/";
      license = licenses.gpl2;
      description = "The open-source Java Development Kit";
      maintainers = with maintainers; [ edwtjo asbachb ];
      platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" "armv7l-linux" "armv6l-linux" ];
    };

    passthru = {
      architecture = "";
      home = "${openjdk}/lib/openjdk";
      inherit gtk3;
    };
  };
in openjdk
