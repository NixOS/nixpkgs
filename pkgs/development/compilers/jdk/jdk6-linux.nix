{ swingSupport ? true
, stdenv
, fetchurl
, unzip
, makeWrapper
, xlibs ? null
, installjdk ? true
, pluginSupport ? true
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";
assert swingSupport -> xlibs != null;

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
      abort "jdk requires i686-linux or x86_64 linux";

in

stdenv.mkDerivation {
  name =
    if installjdk then "jdk-1.6.0_32b03" else "jre-1.6.0_32b03";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = http://www.java.net/download/jdk6/6u32/promoted/b03/binaries/jdk-6u32-ea-bin-b03-linux-i586-29_feb_2012.bin;
        md5 = "7c009afa399476c7d2791386235b8e3b";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://www.java.net/download/jdk6/6u32/promoted/b03/binaries/jdk-6u32-ea-bin-b03-linux-amd64-29_feb_2012.bin;
        md5 = "7f1a45531a04c372e5660a55c2dfdad8";
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

  buildInputs = [unzip makeWrapper];
  
  /**
   * libXt is only needed on amd64
   */
  libraries =
    [stdenv.gcc.libc] ++
    (if swingSupport then [xlibs.libX11 xlibs.libXext xlibs.libXtst xlibs.libXi xlibs.libXp xlibs.libXt] else []);

  inherit swingSupport pluginSupport architecture;
  inherit (xlibs) libX11;

  mozillaPlugin = if installjdk then "/jre/lib/${architecture}/plugins" else "/lib/${architecture}/plugins";
}
