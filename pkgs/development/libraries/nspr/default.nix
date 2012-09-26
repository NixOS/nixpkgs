{ stdenv, fetchurl }:

let version = "4.9.2"; in

stdenv.mkDerivation {
  name = "nspr-${version}";

  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v${version}/src/nspr-${version}.tar.gz";
    sha1 = "455eab365f8fd732a4b014ca0af685f3c2dec598";
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
