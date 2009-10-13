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

stdenv.mkDerivation ({
  name =
    if installjdk then "jdk-1.6.0_16" else "jre-1.6.0_16";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = http://download.java.net/dlj/binaries/jdk-6u16-dlj-linux-i586.bin;
        sha256 = "18syxbfsch7j109qcgjh510yvksbzxawf8ij67mx7p92icgf9ss6";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://download.java.net/dlj/binaries/jdk-6u16-dlj-linux-amd64.bin;
        sha256 = "1kxk9wp7i5ymcpnp48qxjbkr749nshi068yld4q3rx2s3hvi824k";
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

  inherit swingSupport pluginSupport;
  inherit (xlibs) libX11;

} // 
  /**
   * comment: there is a plugin for amd64 since 0_13. However it's located in 
   * JRE_STORE_PATH/lib/amd64/libnpjp2.so. I don't know yet how to add it to
   * MOZ_PLUGIN_PATH so that it's found. Put a symlink into ~/.mozilla/plugins
   * instead.
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
