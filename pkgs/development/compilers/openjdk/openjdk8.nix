{ stdenv, fetchurl, cpio, file, which, unzip, zip, xorg, cups, freetype, alsaLib, openjdk, cacert, perl, liberation_ttf, fontconfig } :
let
  update = "40";
  build = "25";
  baseurl = "http://hg.openjdk.java.net/jdk8u/jdk8u40";
  repover = "jdk8u${update}-b${build}";
  paxflags = if stdenv.isi686 then "msp" else "m";
  jdk8 = fetchurl {
             url = "${baseurl}/archive/${repover}.tar.gz";
             sha256 = "05s5j0rq45n8piymv9c1n0hxr4bk3j8lz6fw2wbp0m8kam6zzpza";
          };
  langtools = fetchurl {
             url = "${baseurl}/langtools/archive/${repover}.tar.gz";
             sha256 = "0p1z38szm63cf5f83697awbqwpf7b8q1ymrqc0v6r9hb5yf0p22r";
          };
  hotspot = fetchurl {
             url = "${baseurl}/hotspot/archive/${repover}.tar.gz";
             sha256 = "0sl0ima3zlbd1ai7qrg4msy5ibg64qpwdrv7z4l8cpalwby26y6p";
          };
  corba = fetchurl {
             url = "${baseurl}/corba/archive/${repover}.tar.gz";
             sha256 = "1ahvhap8av519813yf20v3hbvg82j9bq3gnqlayng1qggfivsb5s";
          };
  jdk = fetchurl {
             url = "${baseurl}/jdk/archive/${repover}.tar.gz";
             sha256 = "0n86fcy1z4z22jcgfnn9agzfi949709hn2x6s8wyhwwa055rjd1a";
          };
  jaxws = fetchurl {
             url = "${baseurl}/jaxws/archive/${repover}.tar.gz";
             sha256 = "0hp19hq0dw3j8zz4mxd6bjk9zqlyr56fhwzgjwmm56b6pwkcmsn7";
          };
  jaxp = fetchurl {
             url = "${baseurl}/jaxp/archive/${repover}.tar.gz";
             sha256 = "037za0hjiwvzvbzsckfxnrrbak1vbd52pmrnd855vxkik08jxp8c";
          };
  nashorn = fetchurl {
             url = "${baseurl}/nashorn/archive/${repover}.tar.gz";
             sha256 = "1np8hkg2fmj5s6ipd1vb8x0z6xy00kbi2ipqca9pxzib58caj6b2";
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
    ln -s "../jdk-${repover}" "jdk";
    ln -s "../hotspot-${repover}" "hotspot";
  '';
  patches = [
    ./fix-java-home.patch
    ./read-truststore-from-env-jdk8.patch
    ./currency-date-range-jdk8.patch
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
  buildFlags = "DEBUG_BINARIES=true all";
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
    perl ${./generate-cacerts.pl} $jre/lib/openjdk/jre/bin/keytool ${cacert}/etc/ca-bundle.crt
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
