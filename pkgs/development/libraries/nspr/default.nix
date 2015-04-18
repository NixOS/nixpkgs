{ stdenv, fetchurl }:

let version = "4.10.8"; in

stdenv.mkDerivation {
  name = "nspr-${version}";

  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v${version}/src/nspr-${version}.tar.gz";
    sha256 = "507ea57c525c0c524dae4857a642b4ef5c9d795518754c7f83422d22fe544a15";
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
