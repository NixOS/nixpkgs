{ swingSupport ? true
, stdenv
, requireFile
, unzip
, makeWrapper
, xlibs ? null
, installjdk ? true
, pluginSupport ? true
, installjce ? false
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

  jce =
    if installjce then
      requireFile {
        name = "jce_policy-6.zip";
        url = http://www.oracle.com/technetwork/java/javase/downloads/jce-6-download-429243.html;
        sha256 = "0qljzfxbikm8br5k7rkamibp1vkyjrf6blbxpx6hn4k46f62bhnh";
      }
    else
      null;
in

stdenv.mkDerivation {
  name =
    if installjdk then "jdk-1.6.0_45b06" else "jre-1.6.0_45b06";

  src =
    if stdenv.system == "i686-linux" then
      requireFile {
        name = "jdk-6u45-linux-i586.bin";
        url = http://www.oracle.com/technetwork/java/javase/downloads/jdk6downloads-1902814.html;
        sha256 = "0mx3d2qlal5zyz1a7ld1yk2rs8pf9sjxs2jzasais3nq30jmlfym";
      }
    else if stdenv.system == "x86_64-linux" then
      requireFile {
        name = "jdk-6u45-linux-x64.bin";
        url = http://www.oracle.com/technetwork/java/javase/downloads/jdk6downloads-1902814.html;
        sha256 = "1s0j1pdr6y8c816d9i86rx4zp12nbhmas1rxksp0r53cn7m3ljbb";
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

  inherit swingSupport pluginSupport architecture jce;
  inherit (xlibs) libX11;

  mozillaPlugin = if installjdk then "/jre/lib/${architecture}/plugins" else "/lib/${architecture}/plugins";

  meta.license = "unfree";
}
