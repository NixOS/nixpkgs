{ stdenv, lib, fetchurl, pkgconfig, lndir, bash, cpio, file, which, unzip, zip
, cups, freetype, alsaLib, cacert, perl, liberation_ttf, fontconfig, zlib
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

  fetchSrc = hashes: fetchurl {
    name = "jdk8-${repover}.tar.gz";
		url = "${baseurl}/archive/${repover}.tar.gz";
		sha256 = if stdenv.isAarch64 then hashes.risc else hashes.cisc;
	};

  fetchModuleSrc = name: hashes: fetchurl {
    name = "${name}-${repover}.tar.gz";
		url = "${baseurl}/${name}/archive/${repover}.tar.gz";
		sha256 = if stdenv.isAarch64 then hashes.risc else hashes.cisc;
	};

  # Run `./generate-jdk8-hashes.sh > /tmp/hashes` and paste /tmp/hashes below:
  jdk8 = fetchSrc {
    cisc = "1nqb2nnwy54x2ysnbkxx9hqbigcgqy7fpm4kghrn4xrc7rs41plm";
    risc = "05flkm3f2bkh87dfll8bprw4bkmba91sy3cvdacqbknxdxyqk66v";
  };

  moduleSrcs = lib.mapAttrs fetchModuleSrc {
    langtools = {
      cisc = "1258cz1bb17blhvkg4q0pqhy5h8iqbj11iarph1qf2v293d9baq3";
      risc = "0b1j87fcv9s19mv278kakvqygkmi2v3zy5197nxvni2q8p6c2i35";
    };
    hotspot = {
      cisc = "1vy1qszb81c24sraapxwb6mzzvx1ml058r69291ir896r7mqjnrj";
      risc = "1n11gr8wwhazyyxc7ff0zqikyhdxqszlca9pdzf0f5k4csgbiarp";
    };
    corba = {
      cisc = "1jfj8gf2yfkj2dwbvnx5wj100yl36w984dhva3vqsfp53qfj0q6g";
      risc = "1c95s7hh45c7my8nh6lzsw4raaxnwcrr0m9g5ph35zyf99xjza2x";
    };
    jdk = {
      cisc = "0pkrws8z9miwak7jdyk56p8azf0gqy5r61pr4rfgzpw77rvr7cz5";
      risc = "0iqspc901g2wizs5j9jzmswbv4vk9jdziqhg3b6msq13v2b34qgf";
    };
    jaxws = {
      cisc = "0pa9ixxhvggkj8lqks9szzqifcr07rqr0c0bvx2zr20lp8jb7mgn";
      risc = "1ki61dagr12wjg2khkaijffx4yn2vljinvbfligi4y6ky22nnhkw";
    };
    jaxp = {
      cisc = "0rg6mvz2ayfd5kkw6lpyskcviz1j5w8i2myfji26d9sxk1c20mww";
      risc = "051adh8c80bzpnh281lcf0inn1dbws5v22rm1jny19xgfww3d3lj";
    };
    nashorn = {
      cisc = "0s7h5mfqpqd2xk1ik4jif96ycixlkqk1icwzqgaarrl91rx380bx";
      risc = "1hwqyfj3n1r2hchd4lza3k6vvgc7m7b2mh27a17psi94b66f0q7h";
    };
  };

  openjdk8 = stdenv.mkDerivation {
    pname = "openjdk" + lib.optionalString headless "-headless";
    version = "8u${update}-${build}";

    srcs = [ jdk8 ] ++ lib.attrValues moduleSrcs;
    sourceRoot = ".";

    outputs = [ "out" "jre" ];

    nativeBuildInputs = [ pkgconfig lndir ];
    buildInputs = [
      cpio file which unzip zip perl openjdk8-bootstrap zlib cups freetype alsaLib
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
    };

    passthru = {
      inherit architecture;
      home = "${openjdk8}/lib/openjdk";
    };
  };
in openjdk8
