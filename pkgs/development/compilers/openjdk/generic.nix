{
  featureVersion,

  lib,
  stdenv,

  fetchurl,
  fetchpatch,

  pkg-config,
  autoconf,
  lndir,
  unzip,
  ensureNewerSourcesForZipFilesHook,

  cpio,
  file,
  which,
  zip,
  perl,
  zlib,
  cups,
  freetype,
  harfbuzz,
  alsa-lib,
  libjpeg,
  giflib,
  libpng,
  lcms2,
  libX11,
  libICE,
  libXext,
  libXrender,
  libXtst,
  libXt,
  libXi,
  libXinerama,
  libXcursor,
  libXrandr,
  fontconfig,

  setJavaClassPath,

  versionCheckHook,

  bash,
  liberation_ttf,
  cacert,

  nixpkgs-openjdk-updater,

  # TODO(@sternenseemann): gtk3 fails to evaluate in pkgsCross.ghcjs.buildPackages
  # which should be fixable, this is a no-rebuild workaround for GHC.
  headless ? lib.versionAtLeast featureVersion "21" && stdenv.targetPlatform.isGhcjs,

  enableJavaFX ? false,
  openjfx17,
  openjfx21,
  openjfx23,
  openjfx_jdk ?
    {
      "17" = openjfx17;
      "21" = openjfx21;
      "23" = openjfx23;
    }
    .${featureVersion} or (throw "JavaFX is not supported on OpenJDK ${featureVersion}"),

  enableGtk ? true,
  gtk3,
  gtk2,
  glib,

  temurin-bin-8,
  temurin-bin-11,
  temurin-bin-17,
  temurin-bin-21,
  temurin-bin-23,
  jdk-bootstrap ?
    {
      "8" = temurin-bin-8;
      "11" = temurin-bin-11;
      "17" = temurin-bin-17;
      "21" = temurin-bin-21;
      "23" = temurin-bin-23;
    }
    .${featureVersion},
}:

let
  sourceFile = ./. + "/${featureVersion}/source.json";
  source = nixpkgs-openjdk-updater.openjdkSource {
    inherit sourceFile;
    featureVersionPrefix = tagPrefix + featureVersion;
  };

  atLeast11 = lib.versionAtLeast featureVersion "11";
  atLeast17 = lib.versionAtLeast featureVersion "17";
  atLeast21 = lib.versionAtLeast featureVersion "21";
  atLeast23 = lib.versionAtLeast featureVersion "23";

  tagPrefix = if atLeast11 then "jdk-" else "jdk";
  # TODO: Merge these `lib.removePrefix` calls once update scripts have
  # been run.
  version = lib.removePrefix tagPrefix (lib.removePrefix "refs/tags/" source.src.rev);
  versionSplit =
    # TODO: Remove `-ga` logic once update scripts have been run.
    builtins.match (if atLeast11 then "(.+)[-+](.+)" else "(.+)-b?(.+)") version;
  versionBuild = lib.elemAt versionSplit 1;

  # The JRE 8 libraries are in directories that depend on the CPU.
  architecture =
    if atLeast11 then
      ""
    else
      {
        i686-linux = "i386";
        x86_64-linux = "amd64";
        aarch64-linux = "aarch64";
        powerpc64le-linux = "ppc64le";
      }
      .${stdenv.system} or (throw "Unsupported platform ${stdenv.system}");

  jdk-bootstrap' = jdk-bootstrap.override {
    # when building a headless jdk, also bootstrap it with a headless jdk
    gtkSupport = !headless;
  };
in

assert lib.assertMsg (lib.pathExists sourceFile)
  "OpenJDK ${featureVersion} is not a supported version";

stdenv.mkDerivation (finalAttrs: {
  pname = "openjdk" + lib.optionalString headless "-headless";
  inherit version;

  outputs =
    [
      "out"
    ]
    ++ lib.optionals (!atLeast11) [
      "jre"
    ];

  inherit (source) src;

  patches =
    [
      (
        if atLeast21 then
          ./21/patches/fix-java-home-jdk21.patch
        else if atLeast11 then
          ./11/patches/fix-java-home-jdk10.patch
        else
          ./8/patches/fix-java-home-jdk8.patch
      )
      (
        if atLeast11 then
          ./11/patches/read-truststore-from-env-jdk10.patch
        else
          ./8/patches/read-truststore-from-env-jdk8.patch
      )
    ]
    ++ lib.optionals (!atLeast23) [
      (
        if atLeast11 then
          ./11/patches/currency-date-range-jdk10.patch
        else
          ./8/patches/currency-date-range-jdk8.patch
      )
    ]
    ++ lib.optionals atLeast11 [
      (
        if atLeast17 then
          ./17/patches/increase-javadoc-heap-jdk13.patch
        else
          ./11/patches/increase-javadoc-heap.patch
      )
    ]
    ++ lib.optionals atLeast17 [
      (
        if atLeast21 then
          ./21/patches/ignore-LegalNoticeFilePlugin-jdk18.patch
        else
          ./17/patches/ignore-LegalNoticeFilePlugin-jdk17.patch
      )
    ]
    ++ lib.optionals (!atLeast21) [
      (
        if atLeast17 then
          ./17/patches/fix-library-path-jdk17.patch
        else if atLeast11 then
          ./11/patches/fix-library-path-jdk11.patch
        else
          ./8/patches/fix-library-path-jdk8.patch
      )
    ]
    ++ lib.optionals (atLeast17 && !atLeast23) [
      # -Wformat etc. are stricter in newer gccs, per
      # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79677
      # so grab the work-around from
      # https://src.fedoraproject.org/rpms/java-openjdk/pull-request/24
      (fetchurl {
        url = "https://src.fedoraproject.org/rpms/java-openjdk/raw/06c001c7d87f2e9fe4fedeef2d993bcd5d7afa2a/f/rh1673833-remove_removal_of_wformat_during_test_compilation.patch";
        sha256 = "082lmc30x64x583vqq00c8y0wqih3y4r0mp1c4bqq36l22qv6b6r";
      })
    ]
    ++ lib.optionals (featureVersion == "17") [
      # Patch borrowed from Alpine to fix build errors with musl libc and recent gcc.
      # This is applied anywhere to prevent patchrot.
      (fetchurl {
        url = "https://git.alpinelinux.org/aports/plain/community/openjdk17/FixNullPtrCast.patch?id=41e78a067953e0b13d062d632bae6c4f8028d91c";
        sha256 = "sha256-LzmSew51+DyqqGyyMw2fbXeBluCiCYsS1nCjt9hX6zo=";
      })
    ]
    ++ lib.optionals atLeast11 [
      # Fix build for gnumake-4.4.1:
      #   https://github.com/openjdk/jdk/pull/12992
      (fetchpatch {
        name = "gnumake-4.4.1";
        url = "https://github.com/openjdk/jdk/commit/9341d135b855cc208d48e47d30cd90aafa354c36.patch";
        hash = "sha256-Qcm3ZmGCOYLZcskNjj7DYR85R4v07vYvvavrVOYL8vg=";
      })
    ]
    ++ lib.optionals (featureVersion == "17") [
      # Backport fixes for musl 1.2.4 which are already applied in jdk21+
      # Fetching patch from chimera because they already went through the effort of rebasing it onto jdk17
      (fetchurl {
        name = "lfs64.patch";
        url = "https://raw.githubusercontent.com/chimera-linux/cports/4614075d19e9c9636f3f7e476687247f63330a35/contrib/openjdk17/patches/lfs64.patch";
        hash = "sha256-t2mRbdEiumBAbIAC0zsJNwCn59WYWHsnRtuOSL6bWB4=";
      })
    ]
    ++ lib.optionals (!headless && enableGtk) [
      (
        if atLeast17 then
          ./17/patches/swing-use-gtk-jdk13.patch
        else if atLeast11 then
          ./11/patches/swing-use-gtk-jdk10.patch
        else
          ./8/patches/swing-use-gtk-jdk8.patch
      )
    ];

  nativeBuildInputs =
    [
      pkg-config
    ]
    ++ lib.optionals atLeast11 [
      autoconf
    ]
    ++ lib.optionals (!atLeast11) [
      lndir
    ]
    ++ [
      unzip
    ]
    ++ lib.optionals atLeast21 [
      ensureNewerSourcesForZipFilesHook
    ];

  buildInputs =
    [
      # TODO: Many of these should likely be in `nativeBuildInputs`.
      cpio
      file
      which
      zip
      perl
      zlib
      cups
      freetype
    ]
    ++ lib.optionals (atLeast11 && !atLeast21) [
      harfbuzz
    ]
    ++ [
      alsa-lib
      libjpeg
      giflib
    ]
    ++ lib.optionals atLeast11 [
      libpng
      zlib # duplicate
      lcms2
    ]
    ++ [
      libX11
      libICE
    ]
    ++ lib.optionals (!atLeast11) [
      libXext
    ]
    ++ [
      libXrender
    ]
    ++ lib.optionals atLeast11 [
      libXext
    ]
    ++ [
      libXtst
      libXt
      libXtst # duplicate
      libXi
      libXinerama
      libXcursor
      libXrandr
      fontconfig
      jdk-bootstrap'
    ]
    ++ lib.optionals (!headless && enableGtk) [
      (if atLeast11 then gtk3 else gtk2)
      glib
    ];

  propagatedBuildInputs = lib.optionals (!atLeast11) [ setJavaClassPath ];

  nativeInstallCheckInputs = lib.optionals atLeast23 [
    versionCheckHook
  ];

  # JDK's build system attempts to specifically detect
  # and special-case WSL, and we don't want it to do that,
  # so pass the correct platform names explicitly
  ${if atLeast17 then "configurePlatforms" else null} = [
    "build"
    "host"
  ];

  # https://openjdk.org/groups/build/doc/building.html
  configureFlags =
    [
      "--with-boot-jdk=${jdk-bootstrap'.home}"
    ]
    ++ (
      if atLeast23 then
        [
          "--with-version-string=${version}"
          "--with-vendor-version-string=(nix)"
        ]
      else if atLeast11 then
        lib.optionals atLeast17 [
          "--with-version-build=${versionBuild}"
          "--with-version-opt=nixos"
        ]
        ++ [
          "--with-version-pre="
        ]
      else
        [
          "--with-update-version=${lib.removePrefix "${featureVersion}u" (lib.elemAt versionSplit 0)}"
          "--with-build-number=${versionBuild}"
          "--with-milestone=fcs"
        ]
    )
    ++ [
      "--enable-unlimited-crypto"
      "--with-native-debug-symbols=internal"
    ]
    ++ lib.optionals (!atLeast21) (
      if atLeast11 then
        [
          "--with-freetype=system"
          "--with-harfbuzz=system"
        ]
      else
        [
          "--disable-freetype-bundling"
        ]
    )
    ++ (
      if atLeast11 then
        [
          "--with-libjpeg=system"
          "--with-giflib=system"
          "--with-libpng=system"
          "--with-zlib=system"
          "--with-lcms=system"
        ]
      else
        [
          "--with-zlib=system"
          "--with-giflib=system"
        ]
    )
    ++ [
      "--with-stdc++lib=dynamic"
    ]
    ++ lib.optionals (featureVersion == "11") [
      "--disable-warnings-as-errors"
    ]
    # OpenJDK 11 cannot be built by recent versions of Clang, as far as I can tell (see
    # https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=260319). Known to
    # compile with LLVM 12.
    ++ lib.optionals (atLeast11 && stdenv.cc.isClang) [
      "--with-toolchain-type=clang"
      # Explicitly tell Clang to compile C++ files as C++, see
      # https://github.com/NixOS/nixpkgs/issues/150655#issuecomment-1935304859
      "--with-extra-cxxflags=-xc++"
    ]
    # This probably shouldn’t apply to OpenJDK 21; see
    # b7e68243306833845cbf92e2ea1e0cf782481a51 which removed it for
    # versions 15 through 20.
    ++ lib.optional (
      (featureVersion == "11" || featureVersion == "21") && stdenv.hostPlatform.isx86_64
    ) "--with-jvm-features=zgc"
    ++ lib.optional headless (if atLeast11 then "--enable-headless-only" else "--disable-headful")
    ++ lib.optional (!headless && enableJavaFX) "--with-import-modules=${openjfx_jdk}";

  buildFlags = if atLeast17 then [ "images" ] else [ "all" ];

  separateDebugInfo = true;

  # -j flag is explicitly rejected by the build system:
  #     Error: 'make -jN' is not supported, use 'make JOBS=N'
  # Note: it does not make build sequential. Build system
  # still runs in parallel.
  enableParallelBuilding = false;

  env =
    {
      NIX_CFLAGS_COMPILE =
        if atLeast17 then
          "-Wno-error"
        else if atLeast11 then
          # Workaround for
          # `cc1plus: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]`
          # when building jtreg
          "-Wformat"
        else
          lib.concatStringsSep " " (
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

      NIX_LDFLAGS = lib.concatStringsSep " " (
        lib.optionals (!headless) [
          "-lfontconfig"
          "-lcups"
          "-lXinerama"
          "-lXrandr"
          "-lmagic"
        ]
        ++ lib.optionals (!headless && enableGtk) [
          (if atLeast11 then "-lgtk-3" else "-lgtk-x11-2.0")
          "-lgio-2.0"
        ]
      );
    }
    // lib.optionalAttrs (!atLeast11) {
      # OpenJDK 8 Hotspot cares about the host(!) version otherwise
      DISABLE_HOTSPOT_OS_VERSION_CHECK = "ok";
    };

  ${if atLeast23 then "versionCheckProgram" else null} = "${placeholder "out"}/bin/java";

  ${if !atLeast11 then "doCheck" else null} = false; # fails with "No rule to make target 'y'."

  doInstallCheck = atLeast23;

  ${if atLeast17 then "postPatch" else null} = ''
    chmod +x configure
    patchShebangs --build configure
  '';

  ${if !atLeast17 then "preConfigure" else null} =
    ''
      chmod +x configure
      substituteInPlace configure --replace /bin/bash "${bash}/bin/bash"
    ''
    + lib.optionalString (!atLeast11) ''
      substituteInPlace hotspot/make/linux/adlc_updater --replace /bin/sh "${stdenv.shell}"
      substituteInPlace hotspot/make/linux/makefiles/dtrace.make --replace /usr/include/sys/sdt.h "/no-such-path"
    '';

  installPhase =
    ''
      mkdir -p $out/lib

      mv build/*/images/${if atLeast11 then "jdk" else "j2sdk-image"} $out/lib/openjdk

      # Remove some broken manpages.
      rm -rf $out/lib/openjdk/man/ja*

      # Mirror some stuff in top-level.
      mkdir -p $out/share
      ln -s $out/lib/openjdk/include $out/include
      ln -s $out/lib/openjdk/man $out/share/man
    ''
    + lib.optionalString atLeast17 ''

      # IDEs use the provided src.zip to navigate the Java codebase (https://github.com/NixOS/nixpkgs/pull/95081)
    ''
    + lib.optionalString atLeast11 ''
      ln -s $out/lib/openjdk/lib/src.zip $out/lib/src.zip
    ''
    + ''

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/linux/*_md.h $out/include/

      # Remove crap from the installation.
      rm -rf $out/lib/openjdk/demo${lib.optionalString (!atLeast11) " $out/lib/openjdk/sample"}
      ${lib.optionalString headless (
        if atLeast11 then
          ''
            rm $out/lib/openjdk/lib/{libjsound,libfontmanager}.so
          ''
        else
          ''
            rm $out/lib/openjdk/jre/lib/${architecture}/{libjsound,libjsoundalsa,libsplashscreen,libawt*,libfontmanager}.so
            rm $out/lib/openjdk/jre/bin/policytool
            rm $out/lib/openjdk/bin/{policytool,appletviewer}
          ''
      )}
    ''
    + lib.optionalString (!atLeast11) ''

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
        perl ${./8/generate-cacerts.pl} $jre/lib/openjdk/jre/bin/keytool ${cacert}/etc/ssl/certs/ca-bundle.crt
      )
    ''
    + ''

      ln -s $out/lib/openjdk/bin $out/bin
    ''
    + lib.optionalString (!atLeast11) ''
      ln -s $jre/lib/openjdk/jre/bin $jre/bin
      ln -s $jre/lib/openjdk/jre $out/jre
    '';

  preFixup =
    (
      if atLeast11 then
        ''
          # Propagate the setJavaClassPath setup hook so that any package
          # that depends on the JDK has $CLASSPATH set up properly.
          mkdir -p $out/nix-support
          #TODO or printWords?  cf https://github.com/NixOS/nixpkgs/pull/27427#issuecomment-317293040
          echo -n "${setJavaClassPath}" > $out/nix-support/propagated-build-inputs
        ''
      else
        ''
          # Propagate the setJavaClassPath setup hook from the JRE so that
          # any package that depends on the JRE has $CLASSPATH set up
          # properly.
          mkdir -p $jre/nix-support
          printWords ${setJavaClassPath} > $jre/nix-support/propagated-build-inputs
        ''
    )
    + ''

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
      LIBDIRS="$(find $(eval echo \$$output) -name \*.so\* -exec dirname {} \+ | ${
        if atLeast17 then "sort -u" else "sort | uniq"
      } | tr '\n' ':'):$LIBDIRS"
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

  # TODO: The OpenJDK 8 derivation got this wrong.
  disallowedReferences = [
    (if atLeast11 then jdk-bootstrap' else jdk-bootstrap)
  ];

  passthru =
    {
      home = "${finalAttrs.finalPackage}/lib/openjdk";
      inherit jdk-bootstrap;
      inherit (source) updateScript;
    }
    // (if atLeast11 then { inherit gtk3; } else { inherit gtk2; })
    // lib.optionalAttrs (!atLeast23) {
      inherit architecture;
    };

  meta = {
    description = "Open-source Java Development Kit";
    homepage = "https://openjdk.java.net/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      edwtjo
      infinidoge
    ];
    mainProgram = "java";
    platforms =
      [
        "i686-linux"
        "x86_64-linux"
        "aarch64-linux"
      ]
      ++ lib.optionals atLeast11 [
        "armv7l-linux"
        "armv6l-linux"
        "powerpc64le-linux"
      ]
      ++ lib.optionals atLeast17 [
        "riscv64-linux"
      ];
    # OpenJDK 8 was broken for musl at 2024-01-17. Tracking issue:
    # https://github.com/NixOS/nixpkgs/issues/281618
    # error: ‘isnanf’ was not declared in this scope
    broken = !atLeast11 && stdenv.hostPlatform.isMusl;
  };
})
