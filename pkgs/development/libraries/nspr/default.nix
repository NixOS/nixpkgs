{ stdenv, fetchurl }:

let version = "4.9.5"; in

stdenv.mkDerivation {
  name = "nspr-${version}";

  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v${version}/src/nspr-${version}.tar.gz";
    sha1 = "03885e992607e2be975f6525c6764c2167fe2eff";
  };

  preConfigure = "cd mozilla/nsprpub";

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
