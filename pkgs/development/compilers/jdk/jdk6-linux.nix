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
    if installjdk then "jdk-1.6.0_6" else "jre-1.6.0_6";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = http://download.java.net/dlj/binaries/jdk-6u6-dlj-linux-i586.bin;
        sha256 = "35ad958d88ed2af892c3879c815988bfae7775dd484e920186d1f8ad02a2c076";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://download.java.net/dlj/binaries/jdk-6u6-dlj-linux-amd64.bin;
        sha256 = "f9e80c53e15d8faf0d3381e2e2540bade4c5f849ff72984a2ed34e3208f0b7ea";
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
    [stdenv.gcc.libc] ++
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
