/* XXX: This is work in progress and it needs your help!  */

/* See http://icedtea.classpath.org/wiki/BuildRequirements for a
   list of dependencies.  */

{ fetchurl, stdenv, which
, wget, cpio, file, ecj, gcj, ant, gawk, procps, inetutils, zip, unzip, zlib
, alsaLib, cups, lesstif, freetype, classpath, libjpeg, libpng, giflib
, xalanj, xerces, rhino
, libX11, libXp, libXtst, libXinerama, libXt, libXrender, xproto
, pkgconfig, xulrunner, pulseaudio }:

let
  # These variables must match those in the top-level `Makefile.am'.
  openjdkVersion   = "b16";
  openjdkDate      = "24_apr_2009";
  openjdkURL       =
    "http://download.java.net/openjdk/jdk6/promoted/${openjdkVersion}/";
  openjdkSourceZip = "openjdk-6-src-${openjdkVersion}-${openjdkDate}.tar.gz";

  openjdk          = fetchurl {
    url = "${openjdkURL}${openjdkSourceZip}";
    sha256 = "084lkhsnj29finb6pmvrh83nqbliwv32gdi5q5sv43dpv24r85cn";
  };

  hotspot          = fetchurl {
    url = "http://hg.openjdk.java.net/hsx/hsx14/master/archive/09f7962b8b44.tar.gz";
    sha256 = "1jbd9ki5ip96293mv1qil20yqcgvkmcrhs302j0n8i8f3v1j70bf";
  };

in

stdenv.mkDerivation rec {
  name = "icedtea6-1.6.1";

  src = fetchurl {
    url = "http://icedtea.classpath.org/download/source/${name}.tar.gz";
    sha256 = "11vaanfmz842x576wrw5qldpkksi8wqjmh9wikn5gxyjk87qq3k5";
  };

  buildInputs = [
    wget  # Not actually used, thanks to `--with-openjdk-src-zip' et al.
    which cpio file ecj gcj ant gawk procps inetutils zip unzip zlib
    alsaLib cups lesstif freetype classpath libjpeg libpng giflib
    xalanj xerces
    libX11 libXp libXtst libXinerama libXt libXrender xproto
    pkgconfig /* xulrunner */ pulseaudio
  ];

  preConfigure =
    '' # Use the Sun-compatible tools (`jar', etc.).
       export PATH="${gcj.gcc}/lib/jvm/bin:$PATH"

       # Copy patches.
       cp -v "${./nixos-slash-bin.patch}" patches/nixos-slash-bin.patch
    '';

  configureFlags =
    stdenv.lib.concatStringsSep " "
      [ "--with-gcj-home=${gcj}"
        "--with-ecj" "--with-ecj-jar=${ecj}/lib/java/ecj.jar"
        "--with-openjdk-src-zip=${openjdk}"
        "--with-hotspot-src-zip=${hotspot}"
        "--with-ant-home=${ant}/lib/java"
        "--with-xalan2-jar=${xalanj}/lib/java/xalan.jar"
        "--with-xalan2-serializer-jar=${xalanj}/lib/java/xalan.jar"
        "--with-xerces2-jar=${xerces}/lib/java/xercesImpl.jar"
        "--with-rhino=${rhino}/lib/java/js.jar"
        "--disable-plugin" # FIXME: Enable it someday.

        "--with-parallel-job"
      ];

  makeFlags =
    [ # Have OpenCDK use tools from $PATH.
      "ALT_UNIXCCS_PATH=" "ALT_UNIXCOMMAND_PATH=" "ALT_USRBIN_PATH="
      "ALT_COMPILER_PATH=" "ALT_DEVTOOLS_PATH="

      # Libraries.
      "ALT_MOTIF_DIR="
      "ALT_FREETYPE_HEADERS_PATH=${freetype}/include"
      "ALT_FREETYPE_LIB_PATH=${freetype}/lib"
      "ALT_CUPS_HEADERS_PATH=${cups}/include"
      "ALT_CUPS_LIB_PATH=${cups}/lib"

      # Tell IcedTea about our patches.
      "DISTRIBUTION_PATCHES=patches/nixos-slash-bin.patch"
    ];

  meta = {
    description = "IcedTea, a libre Java development kit based on OpenJDK";

    longDescription =
      '' The IcedTea project provides a harness to build the source code from
         http://openjdk.java.net using Free Software build tools and adds a
         number of key features to the upstream OpenJDK codebase: a Free
         64-bit plugin with LiveConnect and Java Web Start support, support
         for additional platforms via a pure interpreted mode in HotSpot
         (Zero) or the alternative CACAO virtual machine.  Experimental JIT
         support for Zero is also available via Shark.
      '';

    license = "GPLv2"; /* and multiple-licensing, e.g., for the plug-ins */

    homepage = http://icedtea.classpath.org/;

    maintainers = [ ];

    # Restrict to GNU systems for now.
    platforms = stdenv.lib.platforms.gnu;

    broken = true;
  };
}
