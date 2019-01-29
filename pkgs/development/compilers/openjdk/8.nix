{ stdenv, lib, fetchurl, bash, cpio, pkgconfig, file, which, unzip, zip, cups, freetype
, alsaLib, bootjdk, cacert, perl, liberation_ttf, fontconfig, zlib, lndir
, libX11, libICE, libXrender, libXext, libXt, libXtst, libXi, libXinerama, libXcursor, libXrandr
, libjpeg, giflib
, setJavaClassPath
, minimal ? false
, enableInfinality ? true # font rendering patch
, enableGnome2 ? true, gtk2, gnome_vfs, glib, GConf
}:

let

  /**
   * The JRE libraries are in directories that depend on the CPU.
   */
  architecture =
    if stdenv.hostPlatform.system == "i686-linux" then
      "i386"
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      "amd64"
    else
      throw "openjdk requires i686-linux or x86_64 linux";

  update = "202";
  build = "ga";
  baseurl = "http://hg.openjdk.java.net/jdk8u/jdk8u";
  repover = "jdk8u${update}-${build}";
  jdk8 = fetchurl {
             url = "${baseurl}/archive/${repover}.tar.gz";
             sha256 = "0asx7qkhmrlfmhrljck5gb3yp4v0aa8k35y4xfcph41x0m0mvrdb";
          };
  langtools = fetchurl {
             url = "${baseurl}/langtools/archive/${repover}.tar.gz";
             sha256 = "07q6l3slmi5fgwjnsk6bd8miv8glmw15w5f6yyvp8nlp2d54l33n";
          };
  hotspot = fetchurl {
             url = "${baseurl}/hotspot/archive/${repover}.tar.gz";
             sha256 = "01k4pwhn3nmkzdhdj1v58dgir4iwsj9mm2ml1541z31s53g037cq";
          };
  corba = fetchurl {
             url = "${baseurl}/corba/archive/${repover}.tar.gz";
             sha256 = "0v39kl2iiyh74p3cp6bjhshkwxpgbffza9abzjgp7cpdfhcc73p0";
          };
  jdk = fetchurl {
             url = "${baseurl}/jdk/archive/${repover}.tar.gz";
             sha256 = "0z1cy6aq09j25jyryj47rms15h5175p2h23fg5pv035zapf8nb1b";
          };
  jaxws = fetchurl {
             url = "${baseurl}/jaxws/archive/${repover}.tar.gz";
             sha256 = "0y0mk4sra9d29kgx842m5y4bz9gczc9ypkajv6m5igjv7sizzsv7";
          };
  jaxp = fetchurl {
             url = "${baseurl}/jaxp/archive/${repover}.tar.gz";
             sha256 = "07ssrjhffkdncxxhsbid21hlg51y7js3x7sb4g474vmmi3qj6vmb";
          };
  nashorn = fetchurl {
             url = "${baseurl}/nashorn/archive/${repover}.tar.gz";
             sha256 = "0r0b8ra0ibzbdpxz6nv6i2zrzh2j5sxgprpnl6gf4d9h0i29ickj";
          };
  openjdk8 = stdenv.mkDerivation {
    name = "openjdk-8u${update}b${build}";

    srcs = [ jdk8 langtools hotspot corba jdk jaxws jaxp nashorn ];
    sourceRoot = ".";

    outputs = [ "out" "jre" ];

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [
      cpio file which unzip zip perl bootjdk zlib cups freetype alsaLib
      libjpeg giflib libX11 libICE libXext libXrender libXtst libXt libXtst
      libXi libXinerama libXcursor libXrandr lndir fontconfig
    ] ++ lib.optionals (!minimal && enableGnome2) [
      gtk2 gnome_vfs GConf glib
    ];

    #move the seven other source dirs under the main jdk8u directory,
    #with version suffixes removed, as the remainder of the build will expect
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
    ] ++ lib.optionals (!minimal && enableInfinality) [
      ./004_add-fontconfig.patch
      ./005_enable-infinality.patch
    ] ++ lib.optionals (!minimal && enableGnome2) [
      ./swing-use-gtk-jdk8.patch
    ];

    preConfigure = ''
      chmod +x configure
      substituteInPlace configure --replace /bin/bash "${bash}/bin/bash"
      substituteInPlace hotspot/make/linux/adlc_updater --replace /bin/sh "$shell"
      substituteInPlace hotspot/make/linux/makefiles/dtrace.make --replace /usr/include/sys/sdt.h "/no-such-path"
    ''
    # https://bugzilla.redhat.com/show_bug.cgi?id=1306558
    # https://github.com/JetBrains/jdk8u/commit/eaa5e0711a43d64874111254d74893fa299d5716
    + stdenv.lib.optionalString stdenv.cc.isGNU ''
      NIX_CFLAGS_COMPILE+=" -fno-lifetime-dse -fno-delete-null-pointer-checks -std=gnu++98 -Wno-error"
    '';

    configureFlags = [
      "--with-boot-jdk=${bootjdk.home}"
      "--with-update-version=${update}"
      "--with-build-number=${build}"
      "--with-milestone=fcs"
      "--enable-unlimited-crypto"
      "--disable-debug-symbols"
      "--disable-freetype-bundling"
      "--with-zlib=system"
      "--with-giflib=system"
      "--with-stdc++lib=dynamic"

      # glibc 2.24 deprecated readdir_r so we need this
      # See https://www.mail-archive.com/openembedded-devel@lists.openembedded.org/msg49006.html
      "--with-extra-cflags=\"-Wno-error=deprecated-declarations\""
    ] ++ lib.optional minimal "--disable-headful";

    NIX_LDFLAGS= lib.optionals (!minimal) [
      "-lfontconfig" "-lcups" "-lXinerama" "-lXrandr" "-lmagic"
    ] ++ lib.optionals (!minimal && enableGnome2) [
      "-lgtk-x11-2.0" "-lgio-2.0" "-lgnomevfs-2" "-lgconf-2"
    ];

    buildFlags = [ "all" ];

    doCheck = false; # fails with "No rule to make target 'y'."

    installPhase = ''
      mkdir -p $out/lib/openjdk $out/share $jre/lib/openjdk

      cp -av build/*/images/j2sdk-image/* $out/lib/openjdk

      # Remove some broken manpages.
      rm -rf $out/lib/openjdk/man/ja*

      # Mirror some stuff in top-level.
      mkdir $out/include $out/share/man
      ln -s $out/lib/openjdk/include/* $out/include/
      ln -s $out/lib/openjdk/man/* $out/share/man/

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/linux/*_md.h $out/include/

      # Remove crap from the installation.
      rm -rf $out/lib/openjdk/demo $out/lib/openjdk/sample
      ${lib.optionalString minimal ''
        rm $out/lib/openjdk/jre/lib/${architecture}/{libjsound,libjsoundalsa,libsplashscreen,libawt*,libfontmanager}.so
        rm $out/lib/openjdk/jre/bin/policytool
        rm $out/lib/openjdk/bin/{policytool,appletviewer}
      ''}

      # Move the JRE to a separate output and setup fallback fonts
      mv $out/lib/openjdk/jre $jre/lib/openjdk/
      mkdir $out/lib/openjdk/jre
      ${lib.optionalString (!minimal) ''
        mkdir -p $jre/lib/openjdk/jre/lib/fonts/fallback
        lndir ${liberation_ttf}/share/fonts/truetype $jre/lib/openjdk/jre/lib/fonts/fallback
      ''}
      lndir $jre/lib/openjdk/jre $out/lib/openjdk/jre

      rm -rf $out/lib/openjdk/jre/bina
      ln -s $out/lib/openjdk/bin $out/lib/openjdk/jre/bin

      # Make sure cmm/*.pf are not symlinks:
      # https://youtrack.jetbrains.com/issue/IDEA-147272
      rm -rf $out/lib/openjdk/jre/lib/cmm
      ln -s {$jre,$out}/lib/openjdk/jre/lib/cmm

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

    # FIXME: this is unnecessary once the multiple-outputs branch is merged.
    preFixup = ''
      prefix=$jre stripDirs "$STRIP" "$stripDebugList" "''${stripDebugFlags:--S}"
      patchELF $jre
      propagatedBuildInputs+=" $jre"

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
        LIBDIRS="$(find $(eval echo \$$output) -name \*.so\* -exec dirname {} \+ | sort | uniq | tr '\n' ':'):$LIBDIRS"
      done

      # Add the local library paths to remove dependencies on the bootstrap
      for output in $outputs; do
        OUTPUTDIR=$(eval echo \$$output)
        BINLIBS=$(find $OUTPUTDIR/bin/ -type f; find $OUTPUTDIR -name \*.so\*)
        echo "$BINLIBS" | while read i; do
          patchelf --set-rpath "$LIBDIRS:$(patchelf --print-rpath "$i")" "$i" || true
          patchelf --shrink-rpath "$i" || true
        done
      done

      # Test to make sure that we don't depend on the bootstrap
      for output in $outputs; do
        if grep -q -r '${bootjdk}' $(eval echo \$$output); then
          echo "Extraneous references to ${bootjdk} detected"
          exit 1
        fi
      done
    '';

    meta = with stdenv.lib; {
      homepage = http://openjdk.java.net/;
      license = licenses.gpl2;
      description = "The open-source Java Development Kit";
      maintainers = with maintainers; [ edwtjo nequissimus ];
      platforms = platforms.linux;
    };

    passthru = {
      inherit architecture;
      home = "${openjdk8}/lib/openjdk";
    };
  };
in openjdk8
