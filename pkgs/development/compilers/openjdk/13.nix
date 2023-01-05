{ stdenv, lib, fetchurl, bash, pkg-config, autoconf, cpio, file, which, unzip
, zip, perl, cups, freetype, harfbuzz, alsa-lib, libjpeg, giflib, libpng, zlib, lcms2
, libX11, libICE, libXrender, libXext, libXt, libXtst, libXi, libXinerama
, libXcursor, libXrandr, fontconfig, openjdk13-bootstrap, fetchpatch
, setJavaClassPath
, headless ? false
, enableJavaFX ? openjfx.meta.available, openjfx
, enableGnome2 ? true, gtk3, gnome_vfs, glib, GConf
}:

let
  major = "13";
  update = ".0.2";
  build = "-ga";

  openjdk = stdenv.mkDerivation rec {
    pname = "openjdk" + lib.optionalString headless "-headless";
    version = "${major}${update}${build}";

    src = fetchurl {
      url = "http://hg.openjdk.java.net/jdk-updates/jdk${major}u/archive/jdk-${version}.tar.gz";
      sha256 = "1871ziss7ny19rw8f7bay5vznmhpqbfi4ihn3yygs06wyxhm0zmv";
    };

    nativeBuildInputs = [ pkg-config autoconf unzip ];
    buildInputs = [
      cpio file which zip perl zlib cups freetype harfbuzz alsa-lib libjpeg giflib
      libpng zlib lcms2 libX11 libICE libXrender libXext libXtst libXt libXtst
      libXi libXinerama libXcursor libXrandr fontconfig openjdk13-bootstrap
    ] ++ lib.optionals (!headless && enableGnome2) [
      gtk3 gnome_vfs GConf glib
    ];

    patches = [
      ./fix-java-home-jdk10.patch
      ./read-truststore-from-env-jdk10.patch
      ./currency-date-range-jdk10.patch
      ./increase-javadoc-heap-jdk13.patch
      # -Wformat etc. are stricter in newer gccs, per
      # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79677
      # so grab the work-around from
      # https://src.fedoraproject.org/rpms/java-openjdk/pull-request/24
      (fetchurl {
        url = "https://src.fedoraproject.org/rpms/java-openjdk/raw/06c001c7d87f2e9fe4fedeef2d993bcd5d7afa2a/f/rh1673833-remove_removal_of_wformat_during_test_compilation.patch";
        sha256 = "082lmc30x64x583vqq00c8y0wqih3y4r0mp1c4bqq36l22qv6b6r";
      })
      # Fix gnumake 4.3 incompatibility
      (fetchpatch {
        url = "https://github.com/openjdk/panama-foreign/commit/af5c725b8109ce83fc04ef0f8bf6aaf0b50c0441.patch";
        sha256 = "0ja84kih5wkjn58pml53s59qnavb1z92dc88cbgw7vcyqwc1gs0h";
      })
    ] ++ lib.optionals (!headless && enableGnome2) [
      ./swing-use-gtk-jdk13.patch
    ];

    prePatch = ''
      chmod +x configure
      patchShebangs --build configure
    '';

    configureFlags = [
      "--with-boot-jdk=${openjdk13-bootstrap.home}"
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

    disallowedReferences = [ openjdk13-bootstrap ];

    meta = import ./meta.nix lib version;

    passthru = {
      architecture = "";
      home = "${openjdk}/lib/openjdk";
      inherit gtk3;
    };
  };
in openjdk
