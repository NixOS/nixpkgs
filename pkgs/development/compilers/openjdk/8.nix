{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  lndir,
  bash,
  cpio,
  file,
  which,
  unzip,
  zip,
  cups,
  freetype,
  alsa-lib,
  cacert,
  perl,
  liberation_ttf,
  fontconfig,
  zlib,
  libX11,
  libICE,
  libXrender,
  libXext,
  libXt,
  libXtst,
  libXi,
  libXinerama,
  libXcursor,
  libXrandr,
  libjpeg,
  giflib,
  openjdk8-bootstrap,
  setJavaClassPath,
  headless ? false,
  enableGnome2 ? true,
  gtk2,
  gnome_vfs,
  glib,
  GConf,
}:

let

  /**
    The JRE libraries are in directories that depend on the CPU.
  */
  architecture =
    {
      i686-linux = "i386";
      x86_64-linux = "amd64";
      aarch64-linux = "aarch64";
      powerpc64le-linux = "ppc64le";
    }
    .${stdenv.system} or (throw "Unsupported platform ${stdenv.system}");

  update = "412";
  build = "ga";

  # when building a headless jdk, also bootstrap it with a headless jdk
  openjdk-bootstrap = openjdk8-bootstrap.override { gtkSupport = !headless; };

  openjdk8 = stdenv.mkDerivation rec {
    pname = "openjdk" + lib.optionalString headless "-headless";
    version = "8u${update}-${build}";

    src = fetchFromGitHub {
      owner = "openjdk";
      repo = "jdk8u";
      rev = "jdk${version}";
      sha256 = "sha256-o+H5n5p6JG1giJj9OADgMbQPaoKMzLMFquKH536SHhM=";
    };
    outputs = [
      "out"
      "jre"
    ];

    nativeBuildInputs = [
      pkg-config
      lndir
      unzip
    ];
    buildInputs =
      [
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
        libX11
        libICE
        libXext
        libXrender
        libXtst
        libXt
        libXtst
        libXi
        libXinerama
        libXcursor
        libXrandr
        fontconfig
        openjdk-bootstrap
      ]
      ++ lib.optionals (!headless && enableGnome2) [
        gtk2
        gnome_vfs
        GConf
        glib
      ];

    patches =
      [
        ./fix-java-home-jdk8.patch
        ./read-truststore-from-env-jdk8.patch
        ./currency-date-range-jdk8.patch
        ./fix-library-path-jdk8.patch
      ]
      ++ lib.optionals (!headless && enableGnome2) [
        ./swing-use-gtk-jdk8.patch
      ];

    # Hotspot cares about the host(!) version otherwise
    DISABLE_HOTSPOT_OS_VERSION_CHECK = "ok";

    preConfigure = ''
      chmod +x configure
      substituteInPlace configure --replace /bin/bash "${bash}/bin/bash"
      substituteInPlace hotspot/make/linux/adlc_updater --replace /bin/sh "${stdenv.shell}"
      substituteInPlace hotspot/make/linux/makefiles/dtrace.make --replace /usr/include/sys/sdt.h "/no-such-path"
    '';

    configureFlags = [
      "--with-boot-jdk=${openjdk-bootstrap.home}"
      "--with-update-version=${update}"
      "--with-build-number=${build}"
      "--with-milestone=fcs"
      "--enable-unlimited-crypto"
      "--with-native-debug-symbols=internal"
      "--disable-freetype-bundling"
      "--with-zlib=system"
      "--with-giflib=system"
      "--with-stdc++lib=dynamic"
    ] ++ lib.optional headless "--disable-headful";

    separateDebugInfo = true;

    env.NIX_CFLAGS_COMPILE = toString (
      [
        # glibc 2.24 deprecated readdir_r so we need this
        # See https://www.mail-archive.com/openembedded-devel@lists.openembedded.org/msg49006.html
        "-Wno-error=deprecated-declarations"
      ]
      ++ lib.optionals stdenv.cc.isGNU [
        # https://bugzilla.redhat.com/show_bug.cgi?id=1306558
        # https://github.com/JetBrains/jdk8u/commit/eaa5e0711a43d64874111254d74893fa299d5716
        "-fno-lifetime-dse"
        "-fno-delete-null-pointer-checks"
        "-std=gnu++98"
        "-Wno-error"
      ]
    );

    NIX_LDFLAGS = toString (
      lib.optionals (!headless) [
        "-lfontconfig"
        "-lcups"
        "-lXinerama"
        "-lXrandr"
        "-lmagic"
      ]
      ++ lib.optionals (!headless && enableGnome2) [
        "-lgtk-x11-2.0"
        "-lgio-2.0"
        "-lgnomevfs-2"
        "-lgconf-2"
      ]
    );

    # -j flag is explicitly rejected by the build system:
    #     Error: 'make -jN' is not supported, use 'make JOBS=N'
    # Note: it does not make build sequential. Build system
    # still runs in parallel.
    enableParallelBuilding = false;

    buildFlags = [ "all" ];

    doCheck = false; # fails with "No rule to make target 'y'."

    installPhase = ''
      mkdir -p $out/lib

      mv build/*/images/j2sdk-image $out/lib/openjdk

      # Remove some broken manpages.
      rm -rf $out/lib/openjdk/man/ja*

      # Mirror some stuff in top-level.
      mkdir -p $out/share
      ln -s $out/lib/openjdk/include $out/include
      ln -s $out/lib/openjdk/man $out/share/man

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/linux/*_md.h $out/include/

      # Remove crap from the installation.
      rm -rf $out/lib/openjdk/demo $out/lib/openjdk/sample
      ${lib.optionalString headless ''
        rm $out/lib/openjdk/jre/lib/${architecture}/{libjsound,libjsoundalsa,libsplashscreen,libawt*,libfontmanager}.so
        rm $out/lib/openjdk/jre/bin/policytool
        rm $out/lib/openjdk/bin/{policytool,appletviewer}
      ''}

      # Move the JRE to a separate output
      mkdir -p $jre/lib/openjdk
      mv $out/lib/openjdk/jre $jre/lib/openjdk/jre
      mkdir $out/lib/openjdk/jre
      lndir $jre/lib/openjdk/jre $out/lib/openjdk/jre

      # Make sure cmm/*.pf are not symlinks:
      # https://youtrack.jetbrains.com/issue/IDEA-147272
      rm -rf $out/lib/openjdk/jre/lib/cmm
      ln -s {$jre,$out}/lib/openjdk/jre/lib/cmm

      # Setup fallback fonts
      ${lib.optionalString (!headless) ''
        mkdir -p $jre/lib/openjdk/jre/lib/fonts
        ln -s ${liberation_ttf}/share/fonts/truetype $jre/lib/openjdk/jre/lib/fonts/fallback
      ''}

      # Remove duplicate binaries.
      for i in $(cd $out/lib/openjdk/bin && echo *); do
        if [ "$i" = java ]; then continue; fi
        if cmp -s $out/lib/openjdk/bin/$i $jre/lib/openjdk/jre/bin/$i; then
          ln -sfn $jre/lib/openjdk/jre/bin/$i $out/lib/openjdk/bin/$i
        fi
      done

      # Generate certificates.
      (
        cd $jre/lib/openjdk/jre/lib/security
        rm cacerts
        perl ${./generate-cacerts.pl} $jre/lib/openjdk/jre/bin/keytool ${cacert}/etc/ssl/certs/ca-bundle.crt
      )

      ln -s $out/lib/openjdk/bin $out/bin
      ln -s $jre/lib/openjdk/jre/bin $jre/bin
      ln -s $jre/lib/openjdk/jre $out/jre
    '';

    propagatedBuildInputs = [ setJavaClassPath ];

    preFixup = ''
      # Propagate the setJavaClassPath setup hook from the JRE so that
      # any package that depends on the JRE has $CLASSPATH set up
      # properly.
      mkdir -p $jre/nix-support
      printWords ${setJavaClassPath} > $jre/nix-support/propagated-build-inputs

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

    disallowedReferences = [ openjdk8-bootstrap ];

    meta = with lib; {
      homepage = "http://openjdk.java.net/";
      license = licenses.gpl2;
      description = "The open-source Java Development Kit";
      maintainers = with maintainers; [ edwtjo ];
      platforms = [
        "i686-linux"
        "x86_64-linux"
        "aarch64-linux"
      ];
      mainProgram = "java";
    };

    passthru = {
      inherit architecture;
      home = "${openjdk8}/lib/openjdk";
      inherit gtk2;
    };
  };
in
openjdk8
