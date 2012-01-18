{ stdenv
, fetchurl
, unzip
, zip
, procps
, coreutils
, alsaLib
, ant
, freetype
, cups
, which
, jdk
, nettools
, libX11
, libXt
, libXext
, libXrender
, libXtst
, libXi
, cpio
, jreOnly ? false
}:

stdenv.mkDerivation rec {
  name = "openj${if jreOnly then "re" else "dk"}-7b127";

  src = fetchurl {
    url = http://www.java.net/download/openjdk/jdk7/promoted/b147/openjdk-7-fcs-src-b147-27_jun_2011.zip;
    sha256 = "1qhwlz9y5qmwmja4qnxg6sn3pgsg1i11fb9j41w8l26acyhk34rs";
  };

  jaxws_src_name = "jdk7-jaxws2_2_4-b03-2011_05_27.zip";

  jaxws_src = fetchurl {
    url = "http://download.java.net/glassfish/components/jax-ws/openjdk/jdk7/${jaxws_src_name}";
    sha256 = "1mpzgr9lnbf2p3x45npcniy47kbzi3hyqqbd4w3j63sxnxcp5bh5";
  };

  jaxp_src_name = "jaxp145_01.zip";

  jaxp_src = fetchurl {
    url = "http://download.java.net/jaxp/1.4.5/${jaxp_src_name}";
    sha256 = "1js8m1a6lcn95byplmjjs1lja1maisyl6lgfjy1jx3lqi1hlr4n5";
  };

  jaf_src_name = "jdk7-jaf-2010_08_19.zip";

  jaf_src = fetchurl {
    url = "http://java.net/downloads/jax-ws/JDK7/${jaf_src_name}";
    sha256 = "17n0i5cgvfsd6ric70h3n7hr8aqnzd216gaq3603wrxlvggzxbp6";
  };

#  outputs = [ "out" ] ++ stdenv.lib.optionals (! jreOnly) [ "jre" ];

  buildInputs = [
    unzip
    procps
    ant
    which
    zip
    cpio
    nettools
    alsaLib
    libX11
    libXt
    libXext
    libXrender
    libXtst
    libXi
  ];

  postUnpack = ''
    mkdir -p drops
    cp ${jaxp_src} drops/${jaxp_src_name}
    cp ${jaxws_src} drops/${jaxws_src_name}
    cp ${jaf_src} drops/${jaf_src_name}
    export DROPS_PATH=$(pwd)/drops

    sed -i -e "s@/usr/bin/test@${coreutils}/bin/test@" \
      -e "s@/bin/ls@${coreutils}/bin/ls@" \
      openjdk/hotspot/make/linux/makefiles/sa.make

    sed -i "s@/bin/echo -e@${coreutils}/bin/echo -e@" \
      openjdk/{jdk,corba}/make/common/shared/Defs-utils.gmk

    sed -i "s@<Xrender.h>@<X11/extensions/Xrender.h>@" \
      openjdk/jdk/src/solaris/native/sun/java2d/x11/XRSurfaceData.c
  '';

  patches = [
    ./cppflags-include-fix.patch
    ./printf-fix.patch
    ./linux-version-check-fix.patch
  ];

  makeFlags = [
    "SORT=${coreutils}/bin/sort"
    "ALSA_INCLUDE=${alsaLib}/include/alsa/version.h"
    "FREETYPE_HEADERS_PATH=${freetype}/include"
    "FREETYPE_LIB_PATH=${freetype}/lib"
    "MILESTONE=release"
    "BUILD_NUMBER=b127"
    "CUPS_HEADERS_PATH=${cups}/include"
    "USRBIN_PATH="
    "COMPILER_PATH="
    "DEVTOOLS_PATH="
    "UNIXCOMMAND_PATH="
    "BOOTDIR=${jdk}"
    "DROPS_DIR=$(DROPS_PATH)"
  ];

  configurePhase = ''
    make $makeFlags sanity
  '';

  installPhase = ''
    mkdir -p $out
    cp -av build/*/j2${if jreOnly then "re" else "sdk"}-image/* $out
  '';
#  '' + (if jreOnly then "" else ''
#    if [ -z $jre ]; then
#      exit 0
#    fi
#    mkdir -p $jre
#    cp -av build/*/j2re-image/* $jre
#  '');

  meta = {
    homepage = http://openjdk.java.net/;

    license = "GPLv2";

    description = "The open-source Java Development Kit";

    maintainers = [ stdenv.lib.maintainers.shlevy ];

    platforms = stdenv.lib.platforms.linux;
  };
}

