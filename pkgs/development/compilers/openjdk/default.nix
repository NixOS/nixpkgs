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
, libXinerama
, libXcursor
, fontconfig
, cpio
, cacert
, jreOnly ? false
, perl
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

  update = "40";

  build = "43";

in

stdenv.mkDerivation rec {
  name = "openj${if jreOnly then "re" else "dk"}-7u${update}b${build}";

  src = fetchurl {
    url = http://www.java.net/download/openjdk/jdk7u40/promoted/b43/openjdk-7u40-fcs-src-b43-26_aug_2013.zip;
    sha256 = "15h5nmbw6yn5596ccakqdbs0vd8hmslsfg5sfk8wmjvn31bfmy00";
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
    libXinerama
    libXcursor
    fontconfig
    perl
  ];

  NIX_LDFLAGS = "-lfontconfig -lXcursor -lXinerama";

  postUnpack = ''
    sed -i -e "s@/usr/bin/test@${coreutils}/bin/test@" \
      -e "s@/bin/ls@${coreutils}/bin/ls@" \
      openjdk/hotspot/make/linux/makefiles/sa.make

    sed -i "s@/bin/echo -e@${coreutils}/bin/echo -e@" \
      openjdk/{jdk,corba}/make/common/shared/Defs-utils.gmk

    sed -i "s@<Xrender.h>@<X11/extensions/Xrender.h>@" \
      openjdk/jdk/src/solaris/native/sun/java2d/x11/XRSurfaceData.c
  '';

  patches = [ ./cppflags-include-fix.patch ];

  makeFlags = [
    "SORT=${coreutils}/bin/sort"
    "ALSA_INCLUDE=${alsaLib}/include/alsa/version.h"
    "FREETYPE_HEADERS_PATH=${freetype}/include"
    "FREETYPE_LIB_PATH=${freetype}/lib"
    "MILESTONE=release"
    "BUILD_NUMBER=b${build}"
    "CUPS_HEADERS_PATH=${cups}/include"
    "USRBIN_PATH="
    "COMPILER_PATH="
    "DEVTOOLS_PATH="
    "UNIXCOMMAND_PATH="
    "BOOTDIR=${jdk}"
    "UNLIMITED_CRYPTO=1"
  ];

  configurePhase = ''
    make $makeFlags sanity
  '';

  installPhase = ''
    mkdir -p $out
    cp -av build/*/j2${if jreOnly then "re" else "sdk"}-image/* $out

    # Remove some broken manpages.
    rm -rf $out/share/man/ja*

    # Remove crap from the installation.
    rm -rf $out/demo $out/sample

    # Generate certificates.
    pushd $out/${if ! jreOnly then "jre/" else ""}lib/security
    rm cacerts
    perl ${./generate-cacerts.pl} $out/bin/keytool ${cacert}/etc/ca-bundle.crt
    popd
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

  passthru = { inherit architecture; };
}
