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
    if installjdk then "jdk-1.6.0_24" else "jre-1.6.0_24";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = http://download.java.net/dlj/binaries/jdk-6u24-dlj-linux-i586.bin;
        sha256 = "003vf5dhizwd1pcvv6jazx59d1dwws1m87fjbjagbnnra7bka89p";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://download.java.net/dlj/binaries/jdk-6u24-dlj-linux-amd64.bin;
        sha256 = "17r1rv82q2zlhkillkgkxsirnkzpbsi6f2qg4sjrg0154sk6iflq";
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
