{ swingSupport ? false
, stdenv
, requireFile
, unzip
, xlibs ? null
, installjdk ? true
}:

assert swingSupport -> xlibs != null;

let

  /**
   * The JRE libraries are in directories that depend on the CPU.
   */
  architecture =
    if stdenv.system == "i686-solaris" then
      "i386"
    else if stdenv.system == "x86_64-solaris" then
      "amd64"
    else
      abort "this JDK requires i686-solaris or x86_64 solaris";

  update = "72";

  build = "";

  # Find new versions at: http://jdk7.java.net/download.html
  x86 = requireFile {
    name   = "jdk-7u72-solaris-i586.tar.gz";
    url    = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
    sha256 = "a3eea6b8e6ba7196ff747001e5cef8f9efaa2c0c5b04dad7ec95476495f85b77";
  };

  amd64 = requireFile {
    name   = "jdk-7u72-solaris-x64.tar.gz";
    url    = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
    sha256 = "23fb42a8f9131b231d097b568521f8e05a4f57879a375010386e665e06d743dc";
  };

in

stdenv.mkDerivation {
  name = "j${if installjdk then "dk" else "re"}-7u${update}b${build}";

  srcs = [x86] ++ stdenv.lib.optional (stdenv.system == "x86_64-solaris") amd64;

  /**
   * If jdk5 is added, make sure to use the original construct script.
   * This copy removes references to kinit, klist, ktab, which seem to be
   * gone in jdk6.
   */

  buildInputs = [unzip];

  installPhase = ''
    # Remove junk
    rm -f  *.zip
    mkdir -p $out
    cp -av * $out
  '';

  dontStrip = true;

  /**
   * libXt is only needed on amd64
   */
  libraries =
    [stdenv.gcc.libc] ++
    (if swingSupport then [xlibs.libX11 xlibs.libXext xlibs.libXtst xlibs.libXi xlibs.libXp xlibs.libXt] else []);

  inherit swingSupport architecture;
  libX11 = (if swingSupport then xlibs.libX11 else null);

  mozillaPlugin = if installjdk then "/jre/lib/${architecture}/plugins" else "/lib/${architecture}/plugins";

  meta.license = "unfree";
  meta.platforms = stdenv.lib.platforms.illumos;
}
