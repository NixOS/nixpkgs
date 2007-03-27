{ swingSupport ? true
, stdenv
, fetchurl
, unzip
, xlibs ? null
, installjdk ? true
, libstdcpp5
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";
assert swingSupport -> xlibs != null;

(stdenv.mkDerivation {
  name =
    if installjdk then "jdk-1.6.0" else "jre-1.6.0";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = http://download.java.net/dlj/binaries/jdk-6-dlj-linux-i586.bin;
        sha256 = "0rw48124fdc5rhafj6qzrysb4w823jbn3awxgn07kcy1nvnrhkqw";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://download.java.net/dlj/binaries/jdk-6-dlj-linux-amd64.bin;
        sha256 = "1hr16f5kr3xcyhkl3yc2qi2kxg2avr3cmlxv4awpnj0930rmvwzi";
      }
    else
      abort "jdk requires i686-linux or x86_64 linux";

  builder = ./dlj-bundle-builder.sh;

  /**
   * If jdk5 is added, make sure to use the original construct script.
   * This copy removes references to kinit, klist, ktab, which seem to be
   * gone in jdk6.
   */
  construct = ./jdk6-construct.sh;
  inherit installjdk;

  /**
   * The JRE libraries are in directories that depend on the CPU.
   */
  architecture =
    if stdenv.system == "i686-linux" then
      "i386"
    else if stdenv.system == "x86_64-linux" then
      "amd64"
    else
      abort "jdk requires i686-linux or x86_64 linux";

  buildInputs = [unzip];
  libraries =
    (if swingSupport then [xlibs.libX11 xlibs.libXext xlibs.libXtst xlibs.libXi] else []);

  # necessary for javaws and mozilla plugin
  makeWrapper = ../../../build-support/make-wrapper/make-wrapper.sh;
  libPath = [libstdcpp5];
  inherit libstdcpp5;
}
//
  {
    inherit swingSupport;
  }
// 
  /**
   * The mozilla plugin is not available in the amd64 distribution (?)
   */
  ( if stdenv.system == "i686-linux" then
      {
        mozillaPlugin =
         if installjdk then "/jre/plugin/i386/ns7" else "/plugin/i386/ns7";
      }
    else
      {}
  )
)