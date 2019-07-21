{ stdenv, lib, fetchurl, bash, cpio, pkgconfig, file, which, unzip, zip, cups, freetype
, alsaLib, cacert, perl, liberation_ttf, fontconfig, zlib
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
    "i686-linux" = "i386";
    "x86_64-linux" = "amd64";
    "aarch64-linux" = "aarch64";
  }.${stdenv.system} or (throw "Unsupported platform");

  update = "212";
  build = if stdenv.isAarch64 then "b04"
          else "ga";
  baseurl = if stdenv.isAarch64 then "https://hg.openjdk.java.net/aarch64-port/jdk8u-shenandoah"
            else "https://hg.openjdk.java.net/jdk8u/jdk8u";
  repover = lib.optionalString stdenv.isAarch64 "aarch64-shenandoah-"
            + "jdk8u${update}-${build}";

  jdk8 = fetchurl {
             name = "jdk8-${repover}.tar.gz";
             url = "${baseurl}/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "0z2n2b5f1jmdzycb7ppqz3dx5sf1rwwd3fvk15zq4cm7908wapjw"
                      else "00rl33h4cl4b4p3hcid765h38x2jdkb14ylh8k1zhnd0ka76crgg";
          };
  langtools = fetchurl {
             name = "langtools-${repover}.tar.gz";
             url = "${baseurl}/langtools/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "0j0fbxj7fkl8bn8lq3s3sssa26hskaf8c9rmsay8r91m4vnxisv1"
                      else "0va6g2dccf1ph6mpwxswbks5axp7zz258cl89qq9r8jn4ni04agw";
          };
  hotspot = fetchurl {
             name = "hotspot-${repover}.tar.gz";
             url = "${baseurl}/hotspot/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "1ld76jx0v1z6755a61k5da0cks7dqwvwc5l8rvyw9r9py1n7421w"
                      else "0sgr9df10hs49pjld6c6kr374v4zwd9s52pc3drz68zrlk71ja4s";
          };
  corba = fetchurl {
             name = "corba-${repover}.tar.gz";
             url = "${baseurl}/corba/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "1jcw90y3d8rnvqpiyyvsx976f5i8d60p0d6652v4mz41pyjjhyw5"
                      else "1hq0sr4k4k4iv815kg72i9lvd7n7mn5pmw96ckk9p1rnyagn9z03";
          };
  jdk = fetchurl {
             name = "jdk-${repover}.tar.gz";
             url = "${baseurl}/jdk/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "19mnlw7igxblxx8qp6l9rn2w0xw1akdx2v1rw6pq14d03dgwby22"
                      else "1fc59jrbfq8l067mggzy5dnrvni7lwaqd7hahs4nqv87kyrfg545";
          };
  jaxws = fetchurl {
             name = "jaxws-${repover}.tar.gz";
             url = "${baseurl}/jaxws/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "1dvlcj5jrwia08im1is9ms6r619jvzkhyg3ls0czh2yycabg6p51"
                      else "1ka2fvyxdmpfhk814s314gx53yvdr19vpsqygx283v9nbq90l1yg";
          };
  jaxp = fetchurl {
             name = "jaxp-${repover}.tar.gz";
             url = "${baseurl}/jaxp/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "1imz7bsiqhhh5qx8hjpm46y7a4j282vmdd6xljz8n148vml2p936"
                      else "15vlgs5v2ax8sqwh7bg50fnlrwlpnkp0myzrvpqs1mcza8pyasp8";
          };
  nashorn = fetchurl {
             name = "nashorn-${repover}.tar.gz";
             url = "${baseurl}/nashorn/archive/${repover}.tar.gz";
             sha256 = if stdenv.isAarch64 then "0rnrzz42f3ismhwj05sim7d05wccp5bcr5rhxgnvs3hjqaqvq51n"
                      else "1jzn0yi0v6lda5y8ib07g1p6zymnbcx9yy6iz8niggpm7205y93h";
          };
  openjdk8 = stdenv.mkDerivation {
    pname = "openjdk" + lib.optionalString headless "-headless";
    version = "8u${update}-${build}";

    srcs = [ jdk8 langtools hotspot corba jdk jaxws jaxp nashorn ];
    sourceRoot = ".";

    outputs = [ "out" "jre" ];

    nativeBuildInputs = [ pkgconfig ];
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

    NIX_CFLAGS_COMPILE = [
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
    ];

    NIX_LDFLAGS= lib.optionals (!headless) [
      "-lfontconfig" "-lcups" "-lXinerama" "-lXrandr" "-lmagic"
    ] ++ lib.optionals (!headless && enableGnome2) [
      "-lgtk-x11-2.0" "-lgio-2.0" "-lgnomevfs-2" "-lgconf-2"
    ];

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
      ln -s $jre/lib/openjdk/jre $out/lib/openjdk/jre

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

    preFixup = ''
      # Propagate the setJavaClassPath setup hook from the JRE so that
      # any package that depends on the JRE has $CLASSPATH set up
      # properly.
      mkdir -p $jre/nix-support
      printWords ${setJavaClassPath} > $jre/nix-support/propagated-build-inputs

      # Set JAVA_HOME automatically.
      mkdir -p $out/nix-support
      cat <<EOF > $out/nix-support/setup-hook
      if [ -z "\$JAVA_HOME" ]; then export JAVA_HOME=$out/lib/openjdk; fi
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
