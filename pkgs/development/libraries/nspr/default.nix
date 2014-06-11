{ stdenv, fetchurl }:

let version = "4.10.6"; in

stdenv.mkDerivation {
  name = "nspr-${version}";

  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v${version}/src/nspr-${version}.tar.gz";
    sha1 = "3hzcslcfql1rg7drvcn4nmrigy7jfgwz";
  };

  preConfigure = "cd nspr";

  configureFlags = "--enable-optimize --disable-debug ${if stdenv.is64bit then "--enable-64bit" else ""}";

  postInstall =
    ''
      find $out -name "*.a" | xargs rm
    '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.mozilla.org/projects/nspr/;
    description = "Netscape Portable Runtime, a platform-neutral API for system-level and libc-like functions";
  };
}
