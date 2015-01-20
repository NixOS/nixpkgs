{ stdenv, fetchurl, cpio, file, which, unzip, zip, xorg, cups, freetype, alsaLib, openjdk, cacert, perl } :
let
  update = "25";
  build = "18";
  baseurl = "http://hg.openjdk.java.net/jdk8u/jdk8u";
  repover = "jdk8u${update}-b${build}";
  paxflags = if stdenv.isi686 then "msp" else "m";
  jdk8 = fetchurl {
             url = "${baseurl}/archive/${repover}.tar.gz";
             sha256 = "90eb3f3cb7094e609686168ec52ba462ef0f9832a4264bd1575e5896a6dd85c3";
          };
  langtools = fetchurl {
             url = "${baseurl}/langtools/archive/${repover}.tar.gz";
             sha256 = "f292afe8540436090489841771259b274e3c36d42f11d0f58ba8082cd24fcc66";
          };
  hotspot = fetchurl {
             url = "${baseurl}/hotspot/archive/${repover}.tar.gz";
             sha256 = "e574567b48f57c5cdeebae6fa22e2482c05446dbf9133e820f2d95e99459ddf2";
          };
  corba = fetchurl {
             url = "${baseurl}/corba/archive/${repover}.tar.gz";
             sha256 = "61d0bba710d6803b0368c93bc9182b0b40348eed81d578886a03904baf61ba6f";
          };
  jdk = fetchurl {
             url = "${baseurl}/jdk/archive/${repover}.tar.gz";
             sha256 = "8ef05535a0e03c4262d55cc67887e884f3fda8e4872cbc2941dcb216ef1460ca";
          };
  jaxws = fetchurl {
             url = "${baseurl}/jaxws/archive/${repover}.tar.gz";
             sha256 = "afbdf119af2ffc0f9cd6eb93e6dac8e6a56a4ed4b68c7ff07f9b0c1a6bd56a8f";
          };
  jaxp = fetchurl {
             url = "${baseurl}/jaxp/archive/${repover}.tar.gz";
             sha256 = "2e91c958024e6b64f7484b8225e07edce3bd3bcde43081fb73f32e4b73ef7b87";
          };
  nashorn = fetchurl {
             url = "${baseurl}/nashorn/archive/${repover}.tar.gz";
             sha256 = "98b4fc2d448920b81404ce745d9c00e9a33b58e123176dec4074caf611c3f9c2";
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
    platforms = stdenv.lib.platforms.linux;
  };

}
