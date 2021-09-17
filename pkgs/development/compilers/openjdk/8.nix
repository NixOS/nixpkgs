{ stdenv, lib, fetchurl, pkg-config, lndir, bash, cpio, file, which, unzip, zip
, cups, freetype, alsa-lib, cacert, perl, liberation_ttf, fontconfig, zlib
, libX11, libICE, libXrender, libXext, libXt, libXtst, libXi, libXinerama, libXcursor, libXrandr
, libjpeg, giflib
, openjdk8-bootstrap
, setJavaClassPath
, headless ? false
, enableGnome2 ? true, gtk2, gnome_vfs, glib, GConf
}:

let

  /**
   * The JRE libraries are in directories that depend on the CPU.
   */
  architecture = {
    i686-linux = "i386";
    x86_64-linux = "amd64";
    aarch64-linux = "aarch64";
  }.${stdenv.system} or (throw "Unsupported platform");

  update = "272";
  build = if stdenv.isAarch64 then "b10" else "b10";
  baseurl = if stdenv.isAarch64 then "https://hg.openjdk.java.net/aarch64-port/jdk8u-shenandoah"
            else "https://hg.openjdk.java.net/jdk8u/jdk8u";
  repover = lib.optionalString stdenv.isAarch64 "aarch64-shenandoah-"
            + "jdk8u${update}-${build}";

  jdk8 = fetchurl {
             name = "jdk8-${repover}.tar.gz";
             url = "${baseurl}/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "db98897d6fddce85996a9b0daf4352abce4578be0b51eada41702ee1469dd415"
                      else "8f0e8324d3500432e8ed642b4cc7dff90a617dbb2a18a94c07c1020d32f93b7a";
          };
  langtools = fetchurl {
             name = "langtools-${repover}.tar.gz";
             url = "${baseurl}/langtools/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "6544c1cc455844bbbb3d2914ffc716b1cee7f19e6aa223764d41a7cddc41322c"
                      else "632417b0b067c929eda6958341352e29c5810056a5fec138641eb3503f9635b7";
          };
  hotspot = fetchurl {
             name = "hotspot-${repover}.tar.gz";
             url = "${baseurl}/hotspot/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "37abb89e66641607dc6f372946bfc6bd413f23fec0b9c3baf75f41ce517e21d8"
                      else "2142f3b769800a955613b51ffe192551bab1db95b0c219900cf34febc6f20245";
          };
  corba = fetchurl {
             name = "corba-${repover}.tar.gz";
             url = "${baseurl}/corba/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "5da82f7b4aceff32e02d2f559033e3b62b9509d79f1a6891af871502e1d125b1"
                      else "320098d64c843c1ff2ae62579817f9fb4a81772bc0313a543ce68976ad7a6d98";
          };
  jdk = fetchurl {
             name = "jdk-${repover}.tar.gz";
             url = "${baseurl}/jdk/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "ee613296d823605dcd1a0fe2f89b4c7393bdb8ae5f2659f48f5cbc0012bb1a47"
                      else "957c24fc58ac723c8cd808ab60c77d7853710148944c8b9a59f470c4c809e1a0";
          };
  jaxws = fetchurl {
             name = "jaxws-${repover}.tar.gz";
             url = "${baseurl}/jaxws/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "7c426b85f0d378125fa46e6d1b25ddc27ad29d93514d38c5935c84fc540b26ce"
                      else "4efb0ee143dfe86c8ee06db2429fb81a0c8c65af9ea8fc18daa05148c8a1162f";
          };
  jaxp = fetchurl {
             name = "jaxp-${repover}.tar.gz";
             url = "${baseurl}/jaxp/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "928e363877afa7e0ad0c350bb18be6ab056b23708c0624a0bd7f01c4106c2a14"
                      else "25a651c670d5b036042f7244617a3eb11fec80c07745c1c8181a1cdebeda3d8e";
          };
  nashorn = fetchurl {
             name = "nashorn-${repover}.tar.gz";
             url = "${baseurl}/nashorn/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "f060e08c5924457d4f5047c02ad6a987bdbdcd1cea53d2208322073ba4f398c3"
                      else "a28b41d86f0c87ceacd2b686dd31c9bf391d851b1b5187a49ef5e565fc2cbc84";
          };
  openjdk8 = stdenv.mkDerivation {
    pname = "openjdk" + lib.optionalString headless "-headless";
    version = "8u${update}-${build}";

    srcs = [ jdk8 langtools hotspot corba jdk jaxws jaxp nashorn ];
    sourceRoot = ".";

    outputs = [ "out" "jre" ];

    nativeBuildInputs = [ pkg-config lndir unzip ];
    buildInputs = [
      cpio file which zip perl openjdk8-bootstrap zlib cups freetype alsa-lib
      libjpeg giflib libX11 libICE libXext libXrender libXtst libXt libXtst
      libXi libXinerama libXcursor libXrandr fontconfig
    ] ++ lib.optionals (!headless && enableGnome2) [
      gtk2 gnome_vfs GConf glib
    ];

    # move the seven other source dirs under the main jdk8u directory,
    # with version suffixes removed, as the remainder of the build will expect
    prePatch = ''
      mainDir=$(find . -maxdepth 1 -name jdk8u\*);
      find . -maxdepth 1 -name \*jdk\* -not -name jdk8u\* | awk -F- '{print $1}' | while read p; do
        mv $p-* $mainDir/$p
      done
      cd $mainDir
    '';

    patches = [
      ./fix-java-home-jdk8.patch
      ./read-truststore-from-env-jdk8.patch
      ./currency-date-range-jdk8.patch
      ./fix-library-path-jdk8.patch
    ] ++ lib.optionals (!headless && enableGnome2) [
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
      "--with-boot-jdk=${openjdk8-bootstrap.home}"
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

    NIX_CFLAGS_COMPILE = toString ([
      # glibc 2.24 deprecated readdir_r so we need this
      # See https://www.mail-archive.com/openembedded-devel@lists.openembedded.org/msg49006.html
      "-Wno-error=deprecated-declarations"
    ] ++ lib.optionals stdenv.cc.isGNU [
      # https://bugzilla.redhat.com/show_bug.cgi?id=1306558
      # https://github.com/JetBrains/jdk8u/commit/eaa5e0711a43d64874111254d74893fa299d5716
      "-fno-lifetime-dse"
      "-fno-delete-null-pointer-checks"
      "-std=gnu++98"
      "-Wno-error"
    ]);

    NIX_LDFLAGS= toString (lib.optionals (!headless) [
      "-lfontconfig" "-lcups" "-lXinerama" "-lXrandr" "-lmagic"
    ] ++ lib.optionals (!headless && enableGnome2) [
      "-lgtk-x11-2.0" "-lgio-2.0" "-lgnomevfs-2" "-lgconf-2"
    ]);

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

    disallowedReferences = [ openjdk8-bootstrap ];

    meta = with lib; {
      homepage = "http://openjdk.java.net/";
      license = licenses.gpl2;
      description = "The open-source Java Development Kit";
      maintainers = with maintainers; [ edwtjo ];
      platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
      mainProgram = "java";
    };

    passthru = {
      inherit architecture;
      home = "${openjdk8}/lib/openjdk";
      inherit gtk2;
    };
  };
in openjdk8
