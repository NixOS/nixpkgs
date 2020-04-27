{ stdenv, lib, fetchurl, pkgconfig, lndir, bash, cpio, file, which, unzip, zip
, cups, freetype, alsaLib, cacert, perl, liberation_ttf, fontconfig, zlib, glibc
, libX11, libICE, libXrender, libXext, libXt, libXtst, libXi, libXinerama, libXcursor, libXrandr
, xorgproto, libxcb, xtrans, libpthreadstubs, libXau, xcbproto, libXdmcp, xcbutilkeysyms
, autoconf, libpng, libjpeg, giflib, bzip2
, openjdk8-bootstrap
, setJavaClassPath
, headless ? false
, static ? false
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

  update = "252";
  build = "b09";
  baseurl = if stdenv.isAarch64 then "https://hg.openjdk.java.net/aarch64-port/jdk8u-shenandoah"
            else "https://hg.openjdk.java.net/jdk8u/jdk8u";
  repover = lib.optionalString stdenv.isAarch64 "aarch64-shenandoah-"
            + "jdk8u${update}-${build}";

  jdk8 = fetchurl {
             name = "jdk8-${repover}.tar.gz";
             url = "${baseurl}/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "0h8kb7139gmnnqqddj54a1p2wkb5sy5xpisk32i42hw437p85ilj"
                      else "01f0d262wzy30q75dff8185brwqxg5vs094kwhzcjc3c46xddy55";
          };
  langtools = fetchurl {
             name = "langtools-${repover}.tar.gz";
             url = "${baseurl}/langtools/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "1zprms6bl6x8mpak1m9355zwrk88qi7w46mhjq5hymfqqdwgawd9"
                      else "09zffnvxwmk01siq92q88w7bwqrh8j5wcjb0frmaskylxi1xs00r";
          };
  hotspot = fetchurl {
             name = "hotspot-${repover}.tar.gz";
             url = "${baseurl}/hotspot/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "1j22m8hfnasncb0hg6h814qfdw34d7dvr3ljkgwax71938x12ni5"
                      else "1kq3a6qll1sp1wppfg4dqy8j7qx4hpjs732l5m2a95l31ip1p5fr";
          };
  corba = fetchurl {
             name = "corba-${repover}.tar.gz";
             url = "${baseurl}/corba/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "1yrrcnya40sghyyg8m5ncm2giwxlc8j1brif1428qr8anrb6pvaw"
                      else "15s4q5rlpm9dc8v6q648d1l4i4jz29j1lqi1b73nkag2b3vglxax";
          };
  jdk = fetchurl {
             name = "jdk-${repover}.tar.gz";
             url = "${baseurl}/jdk/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "1lf1y3ig8mimsgabd6agsr2j9yv8w9qfcrvsh5hgwj73f23qb6pc"
                      else "0zg2lwk8bbmc1hrzgd951ksb7jrh0rv3zpbg3vdfbhnwq5gq89y1";
          };
  jaxws = fetchurl {
             name = "jaxws-${repover}.tar.gz";
             url = "${baseurl}/jaxws/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "0yw3lmqvn4fsis83wlain3xgn54ryn6vs4bv4is5im7kc8ijpbln"
                      else "117q0x2gzihwra0cf53svjdmikn5fagygc3g4lk4xwsg2jw1whv2";
          };
  jaxp = fetchurl {
             name = "jaxp-${repover}.tar.gz";
             url = "${baseurl}/jaxp/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "0bd8ganxg37pry9j89z7p79dp8nqv9cdqq38iw22w2a77n0yapyy"
                      else "0zfpr0j3i0skb2k4mq2z8nbdkm3f4ncxrrmvf3cmy6j60ck9m30j";
          };
  nashorn = fetchurl {
             name = "nashorn-${repover}.tar.gz";
             url = "${baseurl}/nashorn/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "0lhy2b3vpbjp7zq1kz5mapnasnq0zrfckihwsh77ni9c0hmh9m02"
                      else "1rwgxj5fyarx6n4mhi23f84g8h5m0lpyyj88ym1n7q90chhrfxkx";
          };

  libXdmcp-static = libXdmcp
    .overrideAttrs(oldAttrs: {
      configureFlags = (oldAttrs.configureFlags or []) ++ [
        "--enable-static"
        "--disable-shared"
      ];
    });
  libXau-static = libXau
    .overrideAttrs(oldAttrs: {
      configureFlags = (oldAttrs.configureFlags or []) ++ [
        "--enable-static"
        "--disable-shared"
      ];
    });
  libxcb-static = libxcb
    .overrideAttrs(oldAttrs: {
      configureFlags = (oldAttrs.configureFlags or []) ++ [
        "--enable-static"
        "--disable-shared"
      ];
    });
  libX11-static = libX11
    .overrideAttrs(oldAttrs: {
      configureFlags = (oldAttrs.configureFlags or []) ++ [
        "--enable-static"
        "--disable-shared"
        "--enable-malloc0returnsnull"
      ];
    });
  libpng-static = libpng
    .overrideAttrs(oldAttrs: {
      configureFlags = (oldAttrs.configureFlags or []) ++ [
        "--enable-static"
        "--disable-shared"
      ];
    });
  freetype-static = freetype
    .overrideAttrs(oldAttrs: {
      configureFlags = (oldAttrs.configureFlags or []) ++ [
        "--enable-static"
        "--disable-shared"
      ];
    });
  bzip2-static = bzip2.override { linkStatic = true;};


  openjdk8 = stdenv.mkDerivation rec {
    pname = "openjdk" + lib.optionalString headless "-headless";
    version = "8u${update}-${build}";

    srcs = [ jdk8 langtools hotspot corba jdk jaxws jaxp nashorn ];
    sourceRoot = ".";

    outputs = [ "out" "jre" ];

    nativeBuildInputs = [ pkgconfig lndir ];
    buildInputs = [
      cpio file which unzip zip perl bash
      openjdk8-bootstrap zlib cups freetype alsaLib
      libjpeg giflib libX11 libICE libXext libXrender libXtst libXt libXtst
      libXi libXinerama libXcursor libXrandr fontconfig
    ] ++ lib.optionals (!headless && enableGnome2) [
      gtk2 gnome_vfs GConf glib
    ] ++ lib.optionals (static) [
      autoconf
      bzip2-static
      freetype-static
      glibc
      glibc.static
      libpng-static
      libpthreadstubs
      libXau-static
      libXdmcp-static
      libxcb-static
      libX11-static
      zlib.static
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
    ] ++ lib.optionals static [
      ./openjdk_jvmci_top.patch
      ./openjdk_jvmci_jdk.patch
      ./openjdk8-gcc-static-ld-genSocketOptionRegistry.patch
    ] ++ lib.optionals stdenv.hostPlatform.isMusl [
      ./musl-hotspot-jdk8.patch
      ./musl-hotspot-noagent-jdk8.patch
    ];

    # Hotspot cares about the host(!) version otherwise
    DISABLE_HOTSPOT_OS_VERSION_CHECK = "ok";

    preConfigure = ''
      ${lib.optionalString static "(cd common/autoconf && bash autogen.sh)"}
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
    ] ++ lib.optional headless "--disable-headful"
      ++ lib.optionals (!static) [
      "--with-stdc++lib=dynamic"
      "--disable-freetype-bundling"
      "--with-zlib=system"
      "--with-giflib=system"
     ];

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

    buildFlags = [ "all" ];

    doCheck = false; # fails with "No rule to make target 'y'."

    # static build here means to include static-jdk-libs
    # this will require two stage build
    # https://github.com/oracle/graal/issues/1755#issuecomment-542590772
    buildPhase = lib.optionalString static ''
      # Stage1: build statically to generate static-libs
      ./configure ${toString (configureFlags ++ [ "--enable-static-build=yes" ])}
      make images
      mv build STAGE_1

      # Stage2: compile normally
      ./configure ${toString (configureFlags ++ [ "--enable-static-build=no" ])}
      make images
    '';

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

      ${lib.optionalString static "cp ./STAGE_1/*/jdk/lib/*.a $out/lib"}
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
      maintainers = with maintainers; [ edwtjo nequissimus ];
      platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
    };

    passthru = {
      inherit architecture;
      home = "${openjdk8}/lib/openjdk";
    };
  };
in openjdk8
