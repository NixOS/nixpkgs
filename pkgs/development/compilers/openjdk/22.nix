{ stdenv
, lib
, fetchurl
, fetchpatch
, fetchFromGitHub
, pkg-config
, autoconf
, cpio
, file
, which
, unzip
, zip
, perl
, cups
, freetype
, alsa-lib
, libjpeg
, giflib
, libpng
, zlib
, lcms2
, libX11
, libICE
, libXrender
, libXext
, libXt
, libXtst
, libXi
, libXinerama
, libXcursor
, libXrandr
, fontconfig
, openjdk22-bootstrap
, ensureNewerSourcesForZipFilesHook
, setJavaClassPath
  # TODO(@sternenseemann): gtk3 fails to evaluate in pkgsCross.ghcjs.buildPackages
  # which should be fixable, this is a no-rebuild workaround for GHC.
, headless ? stdenv.targetPlatform.isGhcjs
, enableJavaFX ? false
, openjfx
, enableGnome2 ? true
, gtk3
, gnome_vfs
, glib
, GConf
, writeShellScript
}:

let

  # Java version format:
  # $FEATURE.$INTERIM.$UPDATE.$PATCH
  # See
  # https://openjdk.org/jeps/223
  # https://docs.oracle.com/en/java/javase/22/docs/api/java.base/java/lang/Runtime.Version.html
  featureVersion = "22";
  info = builtins.getAttr featureVersion (lib.importJSON ./info.json);
  version = info.version;

  # when building a headless jdk, also bootstrap it with a headless jdk
  openjdk-bootstrap = openjdk22-bootstrap.override { gtkSupport = !headless; };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "openjdk" + lib.optionalString headless "-headless";
  inherit version;

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = info.repo;
    rev = "jdk-${version}";
    hash = info.hash;
  };

  nativeBuildInputs = [ pkg-config autoconf unzip ensureNewerSourcesForZipFilesHook ];
  buildInputs = [
    cpio
    file
    which
    zip
    perl
    zlib
    cups
    freetype
    alsa-lib
    libjpeg
    giflib
    libpng
    zlib
    lcms2
    libX11
    libICE
    libXrender
    libXext
    libXtst
    libXt
    libXtst
    libXi
    libXinerama
    libXcursor
    libXrandr
    fontconfig
    openjdk-bootstrap
  ] ++ lib.optionals (!headless && enableGnome2) [
    gtk3
    gnome_vfs
    GConf
    glib
  ];

  patches = [
    ./fix-java-home-jdk21.patch
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

    # Fix build for gnumake-4.4.1:
    #   https://github.com/openjdk/jdk/pull/12992
    (fetchpatch {
      name = "gnumake-4.4.1";
      url = "https://github.com/openjdk/jdk/commit/9341d135b855cc208d48e47d30cd90aafa354c36.patch";
      hash = "sha256-Qcm3ZmGCOYLZcskNjj7DYR85R4v07vYvvavrVOYL8vg=";
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
  configurePlatforms = [ "build" "host" ];


  # https://openjdk.org/groups/build/doc/building.html
  configureFlags = [
    "--with-boot-jdk=${openjdk-bootstrap.home}"
    "--with-version-string=${version}"
    "--with-vendor-version-string=(nix)"
    "--enable-unlimited-crypto"
    "--with-native-debug-symbols=internal"
    "--with-libjpeg=system"
    "--with-giflib=system"
    "--with-libpng=system"
    "--with-zlib=system"
    "--with-lcms=system"
    "--with-stdc++lib=dynamic"
  ]
  ++ lib.optional headless "--enable-headless-only"
  ++ lib.optional (!headless && enableJavaFX) "--with-import-modules=${openjfx}";

  separateDebugInfo = true;

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  NIX_LDFLAGS = toString (lib.optionals (!headless) [
    "-lfontconfig"
    "-lcups"
    "-lXinerama"
    "-lXrandr"
    "-lmagic"
  ] ++ lib.optionals (!headless && enableGnome2) [
    "-lgtk-3"
    "-lgio-2.0"
    "-lgnomevfs-2"
    "-lgconf-2"
  ]);

  # -j flag is explicitly rejected by the build system:
  #     Error: 'make -jN' is not supported, use 'make JOBS=N'
  # Note: it does not make build sequential. Build system
  # still runs in parallel.
  enableParallelBuilding = false;

  buildFlags = [ "images" ];

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

  pos = __curPos;
  meta = import ./meta.nix lib featureVersion;

  passthru = {
    updateScript =
      let
        java-json = fetchurl {
          url = "https://search.maven.org/remotecontent?filepath=org/json/json/20240303/json-20240303.jar";
          hash = "sha256-PPbNaJLjLitMHDng9S9SSKL1s3ZG/fu3mma0a2GEFO0=";
        };
      in
      writeShellScript "update-java" ''
        ${finalAttrs.finalPackage}/bin/java \
          -cp ${java-json} \
          ${./JavaUpdater.java} \
          22 pkgs/development/compilers/openjdk/info.json
      '';

    home = "${finalAttrs.finalPackage}/lib/openjdk";

    inherit gtk3;
  };
})
