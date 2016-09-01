{ stdenv, fetchurl
, CoreServices ? null }:

let version = "4.12"; in

stdenv.mkDerivation {
  name = "nspr-${version}";

  src = fetchurl {
    url = "mirror://mozilla/nspr/releases/v${version}/src/nspr-${version}.tar.gz";
    sha256 = "1pk98bmc5xzbl62q5wf2d6mryf0v95z6rsmxz27nclwiaqg0mcg0";
  };

  buildInputs = stdenv.lib.optional stdenv.isDarwin CoreServices;

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  preConfigure = ''
    cd nspr
  '';

  configureFlags = [
    "--enable-optimize"
    "--disable-debug"
  ] ++ stdenv.lib.optional stdenv.is64bit "--enable-64bit";

  postInstall = ''
    find $out -name "*.a" -delete
    moveToOutput share "$dev" # just aclocal
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.mozilla.org/projects/nspr/;
    description = "Netscape Portable Runtime, a platform-neutral API for system-level and libc-like functions";
    platforms = stdenv.lib.platforms.all;
  };
}
