{ swingSupport ? false
, stdenv
, fetchurl
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

  update = "60";

  build = "15";

  # Find new versions at: http://jdk7.java.net/download.html
  x86 = fetchurl {
    url = http://www.java.net/download/jdk7u60/archive/b15/binaries/jdk-7u60-ea-bin-b15-solaris-i586-16_apr_2014.tar.gz;
    md5 = "aa77eb47ce7a1bc5940eb141d99b0d58";
  };

  amd64 = fetchurl {
    url = http://www.java.net/download/jdk7u60/archive/b15/binaries/jdk-7u60-ea-bin-b15-solaris-x64-16_apr_2014.tar.gz;
    md5 = "c6b5370fed79bf0ebd445a22e8f7b846";
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
