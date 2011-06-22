{ stdenv, fetchurl }:

let version = "4.8.8"; in

stdenv.mkDerivation {
  name = "nspr-${version}";

  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v${version}/src/nspr-${version}.tar.gz";
    sha256 = "1jfl97hbb88lpyvhcv6q8zrqyw9wri2m838qdhwkwcgfsbgg9wwj";
  };

  preConfigure = "cd mozilla/nsprpub";

  configureFlags = "--enable-optimize --disable-debug ${if stdenv.is64bit then "--enable-64bit" else ""}";

  postInstall =
    ''
      find $out -name "*.a" | xargs rm
    '';
    
  meta = {
    homepage = http://www.mozilla.org/projects/nspr/;
    description = "Netscape Portable Runtime, a platform-neutral API for system-level and libc-like functions";
  };
}
