{ stdenv, fetchurl, cpio, file, which, unzip, zip, xorg, cups, freetype
, alsaLib, bootjdk, cacert, perl, liberation_ttf, fontconfig, zlib
, setJavaClassPath
, minimal ? false
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

  update = "72";
  build = "04";
  baseurl = "http://hg.openjdk.java.net/jdk8u/jdk8u";
  repover = "jdk8u${update}-b${build}";
  paxflags = if stdenv.isi686 then "msp" else "m";
  jdk8 = fetchurl {
             url = "${baseurl}/archive/${repover}.tar.gz";
             sha256 = "07akz911xr1x28apxpk4vf9d5d76q3kzayjzdmg5czpd25fq122f";
          };
  langtools = fetchurl {
             url = "${baseurl}/langtools/archive/${repover}.tar.gz";
             sha256 = "0d6b213phkrl8mcfydiv1lp9xifwb36rpxlkpkjnamzk4dxsvwwc";
          };
  hotspot = fetchurl {
             url = "${baseurl}/hotspot/archive/${repover}.tar.gz";
             sha256 = "12hzkwy0rhpqkj9imh90x6qi6hdg19mib1vnpb76w27p3yfr7x3j";
          };
  corba = fetchurl {
             url = "${baseurl}/corba/archive/${repover}.tar.gz";
             sha256 = "1qxs34wl3pm99ryy9hvxhl8dyrsj5cj21ci9rf94x8agmbxrjlak";
          };
  jdk = fetchurl {
             url = "${baseurl}/jdk/archive/${repover}.tar.gz";
             sha256 = "0hcf9azgr7p2ry7n117ba5k4q4h15gjh8nx7n8p45h3rr0a0ixh5";
          };
  jaxws = fetchurl {
             url = "${baseurl}/jaxws/archive/${repover}.tar.gz";
             sha256 = "0kymcfk3khaj7j0jpbgcbadkhm82mllm7l7nzrilg4kynf2jrxhr";
          };
  jaxp = fetchurl {
             url = "${baseurl}/jaxp/archive/${repover}.tar.gz";
             sha256 = "1a51qdgam0pmbhaiwvj3p21nlv32q3jw62fjddbjpz0jfx72124p";
          };
  nashorn = fetchurl {
             url = "${baseurl}/nashorn/archive/${repover}.tar.gz";
             sha256 = "1spjlmm0plcg7s9fyrsyf3pljfm5855w3i3yqgp73lgnhn3ihfsd";
          };
  openjdk8 = stdenv.mkDerivation {
    name = "openjdk-8u${update}b${build}";

    srcs = [ jdk8 langtools hotspot corba jdk jaxws jaxp nashorn ];
    sourceRoot = ".";

    outputs = [ "out" "jre" ];

    buildInputs = [
      cpio file which unzip zip
      xorg.libX11 xorg.libXt xorg.libXext xorg.libXrender xorg.libXtst
      xorg.libXi xorg.libXinerama xorg.libXcursor xorg.lndir
      cups freetype alsaLib perl liberation_ttf fontconfig bootjdk zlib
    ];

    prePatch = ''
      ls | grep jdk | grep -v '^jdk8u' | awk -F- '{print $1}' | while read p; do
        mv $p-* $(ls | grep '^jdk8u')/$p
      done
      cd $(ls | grep '^jdk8u')
    '';

    patches = [
      ./fix-java-home-jdk8.patch
      ./read-truststore-from-env-jdk8.patch
      ./currency-date-range-jdk8.patch
    ];

    preConfigure = ''
      chmod +x configure
      substituteInPlace configure --replace /bin/bash "$shell"
      substituteInPlace hotspot/make/linux/adlc_updater --replace /bin/sh "$shell"
    '';

    configureFlags = [
      "--with-freetype=${freetype}"
      "--with-boot-jdk=${bootjdk.home}"
      "--with-update-version=${update}"
      "--with-build-number=${build}"
      "--with-milestone=fcs"
      "--enable-unlimited-crypto"
      "--disable-debug-symbols"
      "--disable-freetype-bundling"
    ] ++ (if minimal then [
      "--disable-headful"
      "--with-zlib=bundled"
      "--with-giflib=bundled"
    ] else [
      "--with-zlib=system"
    ]);

    NIX_LDFLAGS= if minimal then null else "-lfontconfig";

    buildFlags = "all";

    installPhase = ''
      mkdir -p $out/lib/openjdk $out/share $jre/lib/openjdk

      cp -av build/*/images/j2sdk-image/* $out/lib/openjdk

      # Move some stuff to top-level.
      mv $out/lib/openjdk/include $out/include
      mv $out/lib/openjdk/man $out/share/man

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/linux/*_md.h $out/include/

      # Remove some broken manpages.
      rm -rf $out/share/man/ja*

      # Remove crap from the installation.
      rm -rf $out/lib/openjdk/demo $out/lib/openjdk/sample

      # Move the JRE to a separate output and setup fallback fonts
      mv $out/lib/openjdk/jre $jre/lib/openjdk/
      mkdir $out/lib/openjdk/jre
      mkdir -p $jre/lib/openjdk/jre/lib/fonts/fallback
      lndir ${liberation_ttf}/share/fonts/truetype $jre/lib/openjdk/jre/lib/fonts/fallback
      lndir $jre/lib/openjdk/jre $out/lib/openjdk/jre

      rm -rf $out/lib/openjdk/jre/bina
      ln -s $out/lib/openjdk/bin $out/lib/openjdk/jre/bin

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
      pushd $jre/lib/openjdk/jre/lib/security
      rm cacerts
      perl ${./generate-cacerts.pl} $jre/lib/openjdk/jre/bin/keytool ${cacert}/etc/ssl/certs/ca-bundle.crt
      popd

      ln -s $out/lib/openjdk/bin $out/bin
      ln -s $jre/lib/openjdk/jre/bin $jre/bin
    '';

    # FIXME: this is unnecessary once the multiple-outputs branch is merged.
    preFixup = ''
      prefix=$jre stripDirs "$stripDebugList" "''${stripDebugFlags:--S}"
      patchELF $jre
      propagatedNativeBuildInputs+=" $jre"

      # Propagate the setJavaClassPath setup hook from the JRE so that
      # any package that depends on the JRE has $CLASSPATH set up
      # properly.
      mkdir -p $jre/nix-support
      echo -n "${setJavaClassPath}" > $jre/nix-support/propagated-native-build-inputs

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
        LIBDIRS="$(find $(eval echo \$$output) -name \*.so\* -exec dirname {} \; | sort | uniq | tr '\n' ':'):$LIBDIRS"
      done

      # Add the local library paths to remove dependencies on the bootstrap
      for output in $outputs; do
        OUTPUTDIR="$(eval echo \$$output)"
        BINLIBS="$(find $OUTPUTDIR/bin/ -type f; find $OUTPUTDIR -name \*.so\*)"
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
      home = "${openjdk8}/lib/openjdk";
    };
  };
in openjdk8
