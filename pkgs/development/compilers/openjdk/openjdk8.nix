{ stdenv, fetchurl, cpio, file, which, unzip, zip, xorg, cups, freetype
, alsaLib, bootjdk, cacert, perl, liberation_ttf, fontconfig, zlib

, minimal ? false } :
let
  update = "40";
  build = "27";
  baseurl = "http://hg.openjdk.java.net/jdk8u/jdk8u40";
  repover = "jdk8u${update}-b${build}";
  paxflags = if stdenv.isi686 then "msp" else "m";
  jdk8 = fetchurl {
             url = "${baseurl}/archive/${repover}.tar.gz";
             sha256 = "0ra05jngvvy2g1da5b9anrp86m812g2wlkxpijc82kxv6c3h6g28";
          };
  langtools = fetchurl {
             url = "${baseurl}/langtools/archive/${repover}.tar.gz";
             sha256 = "0r9zdq13kgqqm8rgr36qf03h23psxcwzvdqffsncd4jvbfap3n5f";
          };
  hotspot = fetchurl {
             url = "${baseurl}/hotspot/archive/${repover}.tar.gz";
             sha256 = "07v3z38v5fdsx3g28c4pkdq76cdmnc4qflf1wb3lz46lhy230hkd";
          };
  corba = fetchurl {
             url = "${baseurl}/corba/archive/${repover}.tar.gz";
             sha256 = "0y20468f2yi14lijbd732f2mlgrn718pyfji3279l2rm4ad7r7pl";
          };
  jdk = fetchurl {
             url = "${baseurl}/jdk/archive/${repover}.tar.gz";
             sha256 = "1sgfxmkq6z3vj9yq9kszr42b1ijvsknlss353jpcmyr1lljhyvfg";
          };
  jaxws = fetchurl {
             url = "${baseurl}/jaxws/archive/${repover}.tar.gz";
             sha256 = "08p3657d0871pz0g5fg157az9q38r5h2zs49dm7512sc9qrn5c06";
          };
  jaxp = fetchurl {
             url = "${baseurl}/jaxp/archive/${repover}.tar.gz";
             sha256 = "1f1vlrvlvnjbyh8d168smizvmkcm076zc496sxk6njqamby16ip2";
          };
  nashorn = fetchurl {
             url = "${baseurl}/nashorn/archive/${repover}.tar.gz";
             sha256 = "1llf3l4483kd8m1a77n7y9fgvm6fa63nim3qhp5z4gnw68ldbhra";
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
      ./JDK-8074312-hotspot.patch
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

      cp -av build"/"*/images/j2sdk-image"/"* $out/lib/openjdk

      # Move some stuff to top-level.
      mv $out/lib/openjdk/include $out/include
      mv $out/lib/openjdk/man $out/share/man

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/include/linux"/"*_md.h $out/include/

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
      exes=$(file $out/lib/openjdk/bin"/"* $jre/lib/openjdk/jre/bin"/"* 2> /dev/null | grep -E 'ELF.*(executable|shared object)' | sed -e 's/: .*$//')
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

    passthru.home = "${openjdk8}/lib/openjdk";
  };
in openjdk8
