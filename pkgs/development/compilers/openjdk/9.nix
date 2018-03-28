{ stdenv, lib, fetchurl, bash, cpio, pkgconfig, file, which, unzip, zip, cups, freetype
, alsaLib, bootjdk, cacert, perl, liberation_ttf, fontconfig, zlib, lndir
, libX11, libICE, libXrender, libXext, libXt, libXtst, libXi, libXinerama, libXcursor
, libjpeg, giflib
, setJavaClassPath
, minimal ? false
#, enableInfinality ? true # font rendering patch
, enableGnome2 ? true, gtk2, gnome_vfs, glib, GConf
}:

let

  /**
   * The JRE libraries are in directories that depend on the CPU.
   */
  architecture =
    if stdenv.system == "i686-linux" then
      "i386"
    else if stdenv.system == "x86_64-linux" then
      "amd64"
    else
      throw "openjdk requires i686-linux or x86_64 linux";

  update = "9.0.4";
  build = "12";
  baseurl = "http://hg.openjdk.java.net/jdk-updates/jdk9u";
  repover = "jdk-${update}+${build}";
  paxflags = if stdenv.isi686 then "msp" else "m";
  jdk9 = fetchurl {
             url = "${baseurl}/archive/${repover}.tar.gz";
             sha256 = "06hnrzkwxgrfq26il1mjyl6wgb7x3qym69pjbddhl9m29n2si3jh";
          };
  langtools = fetchurl {
             url = "${baseurl}/langtools/archive/${repover}.tar.gz";
             sha256 = "16xqnqn773p6ywcdjx801vbng2skjal7svydn0s7wf3ldqzx64mi";
          };
  hotspot = fetchurl {
             url = "${baseurl}/hotspot/archive/${repover}.tar.gz";
             sha256 = "0g5ddffl2qykrjf17ac9as60rd4sfyv7s2fpgjn86k4a69gkx93v";
          };
  corba = fetchurl {
             url = "${baseurl}/corba/archive/${repover}.tar.gz";
             sha256 = "14585dzs2mfzgzrnbvc062pigngs35hajwpr22m6fzbm7580vnqk";
          };
  jdk = fetchurl {
             url = "${baseurl}/jdk/archive/${repover}.tar.gz";
             sha256 = "16595jdg3y9zy70q8i615a7d6w0zzbydfxylvaq42wrsc7jw733h";
          };
  jaxws = fetchurl {
             url = "${baseurl}/jaxws/archive/${repover}.tar.gz";
             sha256 = "1m1aspc1hq74w0bkasrfvp8ygs6psbc1l61vfw9244j2vgfahjgn";
          };
  jaxp = fetchurl {
             url = "${baseurl}/jaxp/archive/${repover}.tar.gz";
             sha256 = "06ns2giw366vjivb6d46gqwfvfzkaddrgd1x6y8w37ywygp50lxm";
          };
  nashorn = fetchurl {
             url = "${baseurl}/nashorn/archive/${repover}.tar.gz";
             sha256 = "0z6mlzvz1hh1yzli69qjlrcwqdjnivbjbqqrqi4hhpls6z0a2ch7";
          };
  openjdk9 = stdenv.mkDerivation {
    name = "openjdk-${update}-b${build}";

    srcs = [ jdk9 langtools hotspot corba jdk jaxws jaxp nashorn ];
    sourceRoot = ".";

    outputs = [ "out" "jre" ];

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [
      cpio file which unzip zip perl bootjdk zlib cups freetype alsaLib
      libjpeg giflib libX11 libICE libXext libXrender libXtst libXt libXtst
      libXi libXinerama libXcursor lndir fontconfig
    ] ++ lib.optionals (!minimal && enableGnome2) [
      gtk2 gnome_vfs GConf glib
    ];

    #move the seven other source dirs under the main jdk8u directory,
    #with version suffixes removed, as the remainder of the build will expect
    prePatch = ''
      mainDir=$(find . -maxdepth 1 -name jdk9\*);
      find . -maxdepth 1 -name \*jdk\* -not -name jdk9\* | awk -F- '{print $1}' | while read p; do
        mv $p-* $mainDir/$p
      done
      cd $mainDir
    '';

    patches = [
      ./fix-java-home-jdk9.patch
      ./read-truststore-from-env-jdk9.patch
      ./currency-date-range-jdk8.patch
    #] ++ lib.optionals (!minimal && enableInfinality) [
    #  ./004_add-fontconfig.patch
    #  ./005_enable-infinality.patch
    ] ++ lib.optionals (!minimal && enableGnome2) [
      ./swing-use-gtk-jdk9.patch
    ];

    preConfigure = ''
      chmod +x configure
      substituteInPlace configure --replace /bin/bash "${bash}/bin/bash"

      configureFlagsArray=(
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
        "--with-extra-cflags=-Wno-error=deprecated-declarations -Wno-error=format-contains-nul -Wno-error=unused-result"
    ''
    + lib.optionalString minimal "\"--enable-headless-only\""
    + ");"
    # https://bugzilla.redhat.com/show_bug.cgi?id=1306558
    # https://github.com/JetBrains/jdk8u/commit/eaa5e0711a43d64874111254d74893fa299d5716
    + stdenv.lib.optionalString stdenv.cc.isGNU ''
      NIX_CFLAGS_COMPILE+=" -fno-lifetime-dse -fno-delete-null-pointer-checks -std=gnu++98 -Wno-error"
    '';

    NIX_LDFLAGS= lib.optionals (!minimal) [
      "-lfontconfig" "-lcups" "-lXinerama" "-lXrandr" "-lmagic"
    ] ++ lib.optionals (!minimal && enableGnome2) [
      "-lgtk-x11-2.0" "-lgio-2.0" "-lgnomevfs-2" "-lgconf-2"
    ];

    buildFlags = [ "all" ];

    installPhase = ''
      mkdir -p $out/lib/openjdk $out/share $jre/lib/openjdk

      cp -av build/*/images/jdk/* $out/lib/openjdk

      # Remove some broken manpages.
      rm -rf $out/lib/openjdk/man/ja*

      # Mirror some stuff in top-level.
      mkdir $out/include $out/share/man
      ln -s $out/lib/openjdk/include/* $out/include/
      ln -s $out/lib/openjdk/man/* $out/share/man/

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/linux/*_md.h $out/include/

      # Copy the JRE to a separate output and setup fallback fonts
      cp -av build/*/images/jre $jre/lib/openjdk/
      mkdir $out/lib/openjdk/jre
      ${lib.optionalString (!minimal) ''
        mkdir -p $jre/lib/openjdk/jre/lib/fonts/fallback
        lndir ${liberation_ttf}/share/fonts/truetype $jre/lib/openjdk/jre/lib/fonts/fallback
      ''}

      # Remove crap from the installation.
      rm -rf $out/lib/openjdk/demo
      ${lib.optionalString minimal ''
        for d in $out/lib/openjdk/lib $jre/lib/openjdk/jre/lib; do
          rm ''${d}/{libjsound,libjsoundalsa,libawt*,libfontmanager}.so
        done
      ''}

      lndir $jre/lib/openjdk/jre $out/lib/openjdk/jre

      # Make sure cmm/*.pf are not symlinks:
      # https://youtrack.jetbrains.com/issue/IDEA-147272
      # in 9, it seems no *.pf files end up in $out ... ?
      # rm -rf $out/lib/openjdk/jre/lib/cmm
      # ln -s {$jre,$out}/lib/openjdk/jre/lib/cmm

      # Set PaX markings
      exes=$(file $out/lib/openjdk/bin/* $jre/lib/openjdk/jre/bin/* 2> /dev/null | grep -E 'ELF.*(executable|shared object)' | sed -e 's/: .*$//')
      echo "to mark: *$exes*"
      for file in $exes; do
        echo "marking *$file*"
        paxmark ${paxflags} "$file"
      done

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
      prefix=$jre stripDirs "$stripDebugList" "''${stripDebugFlags:--S}"
      patchELF $jre
      propagatedBuildInputs+=" $jre"

      # Propagate the setJavaClassPath setup hook from the JRE so that
      # any package that depends on the JRE has $CLASSPATH set up
      # properly.
      mkdir -p $jre/nix-support
      #TODO or printWords?  cf https://github.com/NixOS/nixpkgs/pull/27427#issuecomment-317293040
      echo -n "${setJavaClassPath}" > $jre/nix-support/propagated-build-inputs

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
      maintainers = with maintainers; [ edwtjo ];
      platforms = platforms.linux;
    };

    passthru = {
      inherit architecture;
      home = "${openjdk9}/lib/openjdk";
    };
  };
in openjdk9
