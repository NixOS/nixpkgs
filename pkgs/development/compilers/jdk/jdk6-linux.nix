{ swingSupport ? true
, stdenv
, fetchurl
, unzip
, makeWrapper
, xlibs ? null
, installjdk ? true
, pluginSupport ? true
, libstdcpp5 ? null
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";
assert swingSupport -> xlibs != null;
assert pluginSupport -> libstdcpp5 != null;

(stdenv.mkDerivation ({
  name =
    if installjdk then "jdk-1.6.0_4" else "jre-1.6.0_4";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = http://download.java.net/dlj/binaries/jdk-6u4-dlj-linux-i586.bin;
        sha256 = "955186f497a50106cd1788fcaf032eedc560985826c8a6c3cb7ab43220cad23c";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://download.java.net/dlj/binaries/jdk-6u4-dlj-linux-amd64.bin;
        sha256 = "be0e21402a79c5b6cd6c96d34451bcc365619cd063930f3ca1c1abe2ee5dbf43";
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

  buildInputs = [unzip makeWrapper];
  libraries =
    (if swingSupport then [xlibs.libX11 xlibs.libXext xlibs.libXtst xlibs.libXi] else []);

  inherit pluginSupport;
} // (
  # necessary for javaws and mozilla plugin
  if pluginSupport then
    {
      libPath = [libstdcpp5];
      inherit libstdcpp5;
    }
  else
    {}
))
//
  {
    inherit swingSupport pluginSupport;
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
