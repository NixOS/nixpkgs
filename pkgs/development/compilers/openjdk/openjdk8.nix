{ stdenv, fetchurl, cpio, file, which, unzip, zip, xorg, cups, freetype, alsaLib, openjdk, cacert, perl } :
let
  update = "31";
  build = "13";
  baseurl = "http://hg.openjdk.java.net/jdk8u/jdk8u";
  repover = "jdk8u${update}-b${build}";
  paxflags = if stdenv.isi686 then "msp" else "m";
  jdk8 = fetchurl {
             url = "${baseurl}/archive/${repover}.tar.gz";
             sha256 = "824b28c554ce32edbdaa77cc4f21f8ed57542c74c8748b89cd06be43a1537b34";
          };
  langtools = fetchurl {
             url = "${baseurl}/langtools/archive/${repover}.tar.gz";
             sha256 = "3e09a644d2fb38970acf78c72bc201c031d43574b5a3f7e00bec1b11bffec9c4";
          };
  hotspot = fetchurl {
             url = "${baseurl}/hotspot/archive/${repover}.tar.gz";
             sha256 = "485b1a88b4b44b468e96211de238a5eed80f7472f91977fc27e2f443a8ab8ed3";
          };
  corba = fetchurl {
             url = "${baseurl}/corba/archive/${repover}.tar.gz";
             sha256 = "47b07945d3f534e6b87dc273676b8bcb493292e8769667493bb5febfb5c9f347";
          };
  jdk = fetchurl {
             url = "${baseurl}/jdk/archive/${repover}.tar.gz";
             sha256 = "b3801935199973cc02df02ac2f2587ff0f1989f98af5bf6fe46520a8108c8d6a";
          };
  jaxws = fetchurl {
             url = "${baseurl}/jaxws/archive/${repover}.tar.gz";
             sha256 = "04bb35fd8b071f65014fa1d3b9816886b88e06548eeda27181993b80efb6a0bf";
          };
  jaxp = fetchurl {
             url = "${baseurl}/jaxp/archive/${repover}.tar.gz";
             sha256 = "74bb7a376fa706e4283e235caebbcf9736974a6a4cf97b8c8335d389581965e2";
          };
  nashorn = fetchurl {
             url = "${baseurl}/nashorn/archive/${repover}.tar.gz";
             sha256 = "2fbdcb016506de4e86db5813c78b28382df5b601f0e73ffd5465c12519b75fd3";
          };
in
stdenv.mkDerivation {
  name = "openjdk-8u${update}b${build}";
  srcs = [jdk8 langtools hotspot corba jdk jaxws jaxp nashorn];
  outputs = [ "out" "jre" ];
  buildInputs = [ cpio file which unzip zip
                  xorg.libX11 xorg.libXt xorg.libXext xorg.libXrender xorg.libXtst
                  xorg.libXi xorg.libXinerama xorg.libXcursor xorg.lndir
                  cups freetype alsaLib openjdk perl ];
  setSourceRoot = ''
    sourceRoot="jdk8u-jdk8u${update}-b${build}";
  '';
  prePatch = ''
    # despite --with-override-jdk the build still searchs here
    ln -s "../jdk-${repover}" "jdk";
    ln -s "../hotspot-${repover}" "hotspot";
  '';
  patches = [
    ./fix-java-home.patch
    ./read-truststore-from-env-jdk8.patch
    ./currency-date-range-jdk8.patch
    ./nonreparenting-wm.patch
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
  buildFlags = "DEBUG_BINARIES=true all";
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

    # Move the JRE to a separate output.
    mv $out/lib/openjdk/jre $jre/lib/openjdk/
    mkdir $out/lib/openjdk/jre
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
    perl ${./generate-cacerts.pl} $jre/lib/openjdk/jre/bin/keytool ${cacert}/etc/ca-bundle.crt
    popd

    ln -s $out/lib/openjdk/bin $out/bin
    ln -s $jre/lib/openjdk/jre/bin $jre/bin
  '';

  meta = {
    homepage = http://openjdk.java.net/;
    license = stdenv.lib.licenses.gpl2;
    description = "The open-source Java Development Kit";
    maintainers = [ stdenv.lib.maintainers.cocreature ];
    platforms = stdenv.lib.platforms.linux;
  };

}
