{ stdenv, lib, fetchurl, bash, cpio, pkgconfig, file, which, unzip, zip, cups, freetype
, alsaLib, bootjdk, cacert, perl, liberation_ttf, fontconfig, zlib, lndir
, libX11, libICE, libXrender, libXext, libXt, libXtst, libXi, libXinerama, libXcursor
, libjpeg, giflib
, setJavaClassPath
, minimal ? false
, enableGnome2 ? true, gtk2, gnome_vfs, glib, GConf
}:

let

  /**
   * The JRE libraries are in directories that depend on the CPU.
   */
  architecture =
    if stdenv.system == "i686-linux" then
      "i386"
    else "amd64";

  update = "10";
  build = "46";
  repover = "jdk-${update}+${build}";
  paxflags = if stdenv.isi686 then "msp" else "m";

  openjdk10 = stdenv.mkDerivation {
    name = "openjdk-${update}-b${build}";

    src = fetchurl {
      url = "http://hg.openjdk.java.net/jdk-updates/jdk10u/archive/${repover}.tar.gz";
      sha256 = "1a2cjad816qilsigkq035rqzfhzmq5vaz1klilrrws456flbsjlg";
    };

    outputs = [ "out" "jre" ];

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [
      cpio file which unzip zip perl bootjdk zlib cups freetype alsaLib
      libjpeg giflib libX11 libICE libXext libXrender libXtst libXt libXtst
      libXi libXinerama libXcursor lndir fontconfig
    ] ++ lib.optionals (!minimal && enableGnome2) [
      gtk2 gnome_vfs GConf glib
    ];

    patches = [
      ./fix-java-home-jdk10.patch
      ./read-truststore-from-env-jdk10.patch
      ./currency-date-range-jdk10.patch
    ] ++ lib.optionals (!minimal && enableGnome2) [
      ./swing-use-gtk-jdk10.patch
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
          rm ''${d}/{libjsound,libjsoundalsa,libfontmanager}.so
        done
      ''}

      lndir $jre/lib/openjdk/jre $out/lib/openjdk/jre

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
      platforms = ["i686-linux" "x86_64-linux"];
    };

    passthru = {
      inherit architecture;
      home = "${openjdk10}/lib/openjdk";
    };
  };
in openjdk10
