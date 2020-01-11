{ stdenv, lib, fetchurl, pkgconfig, lndir, bash, cpio, file, which, unzip, zip
, cups, freetype, alsaLib, cacert, perl, liberation_ttf, fontconfig, zlib
, libX11, libICE, libXrender, libXext, libXt, libXtst, libXi, libXinerama, libXcursor, libXrandr
, libjpeg, giflib
, openjdk8-bootstrap
, setJavaClassPath
, headless ? false
, enableInfinality ? true # font rendering patch
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

  update = "222";
  build = if stdenv.isAarch64 then "b10"
          else "ga";
  baseurl = if stdenv.isAarch64 then "https://hg.openjdk.java.net/aarch64-port/jdk8u-shenandoah"
            else "https://hg.openjdk.java.net/jdk8u/jdk8u";
  repover = lib.optionalString stdenv.isAarch64 "aarch64-shenandoah-"
            + "jdk8u${update}-${build}";

  jdk8 = fetchurl {
             name = "jdk8-${repover}.tar.gz";
             url = "${baseurl}/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "1h19zpmc76f8v4s0mfvqxmxvv8imdwq92z5dmgi19y4xnl978qq8"
                      else "19dyqayn8n2y08p08g34xxnf0dkm6bfjxkp7633m7dx50mjcpxnj";
          };
  langtools = fetchurl {
             name = "langtools-${repover}.tar.gz";
             url = "${baseurl}/langtools/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "09phy2izw2yyp3hnw7jmb7lp559dgnp2a0rymx1k3q97anfz3bzj"
                      else "11nibmqnf7nap10sydk57gimgwpxqk5mn12dyg6fzg4s2fxf0y1q";
          };
  hotspot = fetchurl {
             name = "hotspot-${repover}.tar.gz";
             url = "${baseurl}/hotspot/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "1dqrzg2af94pjam6jg9nq8ydaibn4bsjv7ai6m7m3r2ph2fml80s"
                      else "1g512xrrxvnrk5szg7wqqz00x4gv53dx3yffk5im2zfcalyka2q7";
          };
  corba = fetchurl {
             name = "corba-${repover}.tar.gz";
             url = "${baseurl}/corba/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "15l1ccvk2slx8wf5gilzjvhc428hl57gg1knbma1jqgs3ymnqwpr"
                      else "0h8nprfzpy21mfl39fxxzfa420skwmaaji4r31j7lj3g8c1wp62r";
          };
  jdk = fetchurl {
             name = "jdk-${repover}.tar.gz";
             url = "${baseurl}/jdk/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "179ij3rs1ahl6dh3n64k4xp2prv413ckqk7sj1g5lw48rj7bjh83"
                      else "1sb38h0rckgkr2y0kfzav6mb74nv5whb9l8m842mv1jpavxrdv6k";
          };
  jaxws = fetchurl {
             name = "jaxws-${repover}.tar.gz";
             url = "${baseurl}/jaxws/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "16bayw7c4vzm9s0ixhw2dv6pan6wywyiddh9a8dss35660dnhrm0"
                      else "0akn5zapff5m32ibgm3f4lhgq96bsqx74g4xl38xmivvxddsd6kz";
          };
  jaxp = fetchurl {
             name = "jaxp-${repover}.tar.gz";
             url = "${baseurl}/jaxp/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "176db7pi2irc7q87c273cjm5nrlj5g973fjmh24m6a1jxanrrm9x"
                      else "0bw4q8yhmrl8hqlimy1ijnarav4r91dj73lpr7axba77rqlr41c8";
          };
  nashorn = fetchurl {
             name = "nashorn-${repover}.tar.gz";
             url = "${baseurl}/nashorn/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "0vi3kbsqfpdjxc08ayxk2c87zycd7z0qbqw9xka1vc59iyv97n62"
                      else "0bfcf3iv2lr0xlp6sclxq7zz7b9ahajl008hz5rasjnrnr993qja";
          };
  openjdk8 = stdenv.mkDerivation {
    pname = "openjdk" + lib.optionalString headless "-headless";
    version = "8u${update}-${build}";

    srcs = [ jdk8 langtools hotspot corba jdk jaxws jaxp nashorn ];
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
    ] ++ lib.optionals (!headless && enableInfinality) [
      ./004_add-fontconfig.patch
      ./005_enable-infinality.patch
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
      homepage = http://openjdk.java.net/;
      license = licenses.gpl2;
      description = "The open-source Java Development Kit";
      maintainers = with maintainers; [ edwtjo nequissimus ];
      platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
    };

    passthru = {
      inherit architecture;
      home = "${openjdk8}/lib/openjdk";
    };
  };
in openjdk8
