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
    if installjdk then "jdk-1.6.0_5" else "jre-1.6.0_5";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = http://download.java.net/dlj/binaries/jdk-6u5-dlj-linux-i586.bin;
        sha256 = "b0f78f2e6baf88c1d7dc9334c6b86e621b2c9d629f5617f3f57a3bd7cbad0c99";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://download.java.net/dlj/binaries/jdk-6u5-dlj-linux-amd64.bin;
        sha256 = "9a9b97ce5ac821f9a92541eb5e2353ddefd485eaa1b4f4de6b41fce8281831d4";
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
  
  /**
   * libXt is only needed on amd64
   */
  libraries =
    (if swingSupport then [xlibs.libX11 xlibs.libXext xlibs.libXtst xlibs.libXi xlibs.libXp xlibs.libXt] else []);

  inherit pluginSupport;
} // (
  # necessary for javaws and mozilla plugin
  if pluginSupport then
    {
      libPath = [libstdcpp5];
      inherit libstdcpp5;
    }
  else
    { libPath =  [xlibs.libX11 xlibs.libXext xlibs.libXtst xlibs.libXi xlibs.libXp xlibs.libXt]; }
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
