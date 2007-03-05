{ swingSupport ? true
, stdenv
, fetchurl
, unzip
, xlibs ? null
, installjdk ? true
}:

/**
 * @todo Support x86_64-linux.
 */
assert stdenv.system == "i686-linux";
assert swingSupport -> xlibs != null;

(stdenv.mkDerivation {
  name =
    if installjdk then "jdk-1.6.0" else "jre-1.6.0";

  src =
    fetchurl {
      url = http://download.java.net/dlj/binaries/jdk-6-dlj-linux-i586.bin;
      sha256 = "0rw48124fdc5rhafj6qzrysb4w823jbn3awxgn07kcy1nvnrhkqw";
    };

  builder = ./dlj-bundle-builder.sh;

  /**
   * If jdk5 is added, make sure to use the original construct script.
   * This copy removes references to kinit, klist, ktab, which seem to be
   * gone in jdk.
   */
  construct = ./jdk6-construct.sh;
  inherit installjdk;

  buildInputs = [unzip];
  libraries =
    (if swingSupport then [xlibs.libX11 xlibs.libXext xlibs.libXtst xlibs.libXi] else []);
} // {
  inherit swingSupport;
} // {
  mozillaPlugin =
     if installjdk then "jre/plugin/i386/ns7" else "/plugin/i386/ns7";
  }
)