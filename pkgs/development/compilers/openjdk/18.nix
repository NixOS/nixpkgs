{ stdenv, lib, fetchurl, fetchpatch, fetchFromGitHub, bash, pkg-config, autoconf, cpio
, file, which, unzip, zip, perl, cups, freetype, harfbuzz, alsa-lib, libjpeg, giflib
, libpng, zlib, lcms2, libX11, libICE, libXrender, libXext, libXt, libXtst
, libXi, libXinerama, libXcursor, libXrandr, fontconfig, openjdk18-bootstrap
, setJavaClassPath
, headless ? false
, enableJavaFX ? false, openjfx
, enableGnome2 ? true, gtk3, gnome_vfs, glib, GConf
}:

let
  version = {
    feature = "18";
    build = "36";
  };

  # when building a headless jdk, also bootstrap it with a headless jdk
  openjdk-bootstrap = openjdk18-bootstrap.override { gtkSupport = !headless; };

  openjdk = stdenv.mkDerivation {
    pname = "openjdk" + lib.optionalString headless "-headless";
    version = "${version.feature}+${version.build}";

    src = fetchFromGitHub {
      owner = "openjdk";
      repo = "jdk${version.feature}u";
      rev = "jdk-${version.feature}+${version.build}";
      sha256 = "sha256-yGPC8VA983Ml6Fv/oiEgRrcVe4oe+Q4oCHbzOmFbZq8=";
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
      ./increase-javadoc-heap-jdk13.patch
      ./ignore-LegalNoticeFilePlugin-jdk18.patch

      # -Wformat etc. are stricter in newer gccs, per
      # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79677
      # so grab the work-around from
      # https://src.fedoraproject.org/rpms/java-openjdk/pull-request/24
      (fetchurl {
        url = "https://src.fedoraproject.org/rpms/java-openjdk/raw/06c001c7d87f2e9fe4fedeef2d993bcd5d7afa2a/f/rh1673833-remove_removal_of_wformat_during_test_compilation.patch";
        sha256 = "082lmc30x64x583vqq00c8y0wqih3y4r0mp1c4bqq36l22qv6b6r";
      })

      # Patch borrowed from Alpine to fix build errors with musl libc and recent gcc.
      # This is applied anywhere to prevent patchrot.
      (fetchpatch {
        url = "https://git.alpinelinux.org/aports/plain/testing/openjdk18/FixNullPtrCast.patch?id=b93d1fc37fcf106144958d957bb97c7db67bd41f";
        hash = "sha256-nvO8RcmKwMcPdzq28mZ4If1XJ6FQ76CYWqRIozPCk5U=";
      })
    ] ++ lib.optionals (!headless && enableGnome2) [
      ./swing-use-gtk-jdk13.patch
    ];

    postPatch = ''
      chmod +x configure
      patchShebangs --build configure
    '';

    # JDK's build system attempts to specifically detect
    # and special-case WSL, and we don't want it to do that,
    # so pass the correct platform names explicitly
    configurePlatforms = ["build" "host"];

    configureFlags = [
      "--with-boot-jdk=${openjdk-bootstrap.home}"
      "--with-version-build=${version.build}"
      "--with-version-opt=nixos"
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
    ] ++ lib.optional headless "--enable-headless-only"
      ++ lib.optional (!headless && enableJavaFX) "--with-import-modules=${openjfx}";

    separateDebugInfo = true;

    env.NIX_CFLAGS_COMPILE = "-Wno-error";

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

    buildFlags = [ "images" ];

    postBuild = ''
      cd build/linux*
      make images
      cd -
    '';

    installPhase = ''
      mkdir -p $out/lib

      mv build/*/images/jdk $out/lib/openjdk

      # Remove some broken manpages.
      rm -rf $out/lib/openjdk/man/ja*

      # Mirror some stuff in top-level.
      mkdir -p $out/share
      ln -s $out/lib/openjdk/include $out/include
      ln -s $out/lib/openjdk/man $out/share/man

      # IDEs use the provided src.zip to navigate the Java codebase (https://github.com/NixOS/nixpkgs/pull/95081)
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
        LIBDIRS="$(find $(eval echo \$$output) -name \*.so\* -exec dirname {} \+ | sort -u | tr '\n' ':'):$LIBDIRS"
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

    pos = builtins.unsafeGetAttrPos "feature" version;
    meta = import ./meta.nix lib version.feature;

    passthru = {
      architecture = "";
      home = "${openjdk}/lib/openjdk";
      inherit gtk3;
    };
  };
in openjdk
