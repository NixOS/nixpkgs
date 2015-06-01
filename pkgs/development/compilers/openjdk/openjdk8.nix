{ stdenv, fetchurl, cpio, file, which, unzip, zip, xorg, cups, freetype, alsaLib, openjdk, cacert, perl, liberation_ttf, fontconfig } :
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
  outputs = [ "out" "jre" ];
  buildInputs = [ cpio file which unzip zip
                  xorg.libX11 xorg.libXt xorg.libXext xorg.libXrender xorg.libXtst
                  xorg.libXi xorg.libXinerama xorg.libXcursor xorg.lndir
                  cups freetype alsaLib openjdk perl liberation_ttf fontconfig ];
  setSourceRoot = ''
    sourceRoot="jdk8u${update}-jdk8u${update}-b${build}";
  '';
  prePatch = ''
    # despite --with-override-jdk the build still searchs here
    # GNU Patch bug, --follow-symlinks only follow the last dir part symlink
    mv "../jdk-${repover}" "jdk";
    mv "../hotspot-${repover}" "hotspot";
  '';
  postPatch = ''
    mv jdk "../jdk-${repover}";
    mv hotspot "../hotspot-${repover}";
    # Patching is over, lets re-add the links
    ln -s "../jdk-${repover}" "jdk"
    ln -s "../hotspot-${repover}" "hotspot"
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
    substituteInPlace ../hotspot-${repover}/make/linux/adlc_updater --replace /bin/sh "$shell"
  '';
  configureFlags = [
    "--with-freetype=${freetype}"
    "--with-override-langtools=../langtools-${repover}"
    "--with-override-hotspot=../hotspot-${repover}"
    "--with-override-corba=../corba-${repover}"
    "--with-override-jdk=../jdk-${repover}"
    "--with-override-jaxws=../jaxws-${repover}"
    "--with-override-jaxp=../jaxp-${repover}"
    "--with-override-nashorn=../nashorn-${repover}"
    "--with-boot-jdk=${openjdk}/lib/openjdk/"
    "--with-update-version=${update}"
    "--with-build-number=b${build}"
    "--with-milestone=fcs"
  ];
  NIX_LDFLAGS= "-lfontconfig";
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
    perl ${./generate-cacerts.pl} $jre/lib/openjdk/jre/bin/keytool ${cacert}/ca-bundle.crt
    popd

    ln -s $out/lib/openjdk/bin $out/bin
    ln -s $jre/lib/openjdk/jre/bin $jre/bin

  '';

  meta = with stdenv.lib; {
    homepage = http://openjdk.java.net/;
    license = licenses.gpl2;
    description = "The open-source Java Development Kit";
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };

  passthru.home = "${openjdk8}/lib/openjdk";
}; in openjdk8
