{ swingSupport ? true
, stdenv
, fetchurl
, unzip
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
    if installjdk then "jdk-1.6.0_3" else "jre-1.6.0_3";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = http://download.java.net/dlj/binaries/jdk-6u3-dlj-linux-i586.bin;
        sha256 = "5c44208fbd5f90b3e6a0692ed9e1e98f5feb0c88aa0cfae5186dddb1f05f731b";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://download.java.net/dlj/binaries/jdk-6u3-dlj-linux-amd64.bin;
        sha256 = "8bc80ea1bf739674c1cacdfba9987a4d15adb54f4b1462a0b48b79815f56b311";
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

  inherit pluginSupport;
} // (
  # necessary for javaws and mozilla plugin
  if pluginSupport then
    {
      makeWrapper = ../../../build-support/make-wrapper/make-wrapper.sh;
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
