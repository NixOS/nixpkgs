{ stdenv, fetchurl
, CoreServices ? null }:

let version = "4.18"; in

stdenv.mkDerivation {
  name = "nspr-${version}";

  src = fetchurl {
    url = "mirror://mozilla/nspr/releases/v${version}/src/nspr-${version}.tar.gz";
    sha256 = "0d7vr3wrgp73qbywrvdkikk8vq1s1n9vhf62db80g1zqkg05g5mq";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  preConfigure = ''
    cd nspr
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace '@executable_path/' "$out/lib/"
    substituteInPlace configure.in --replace '@executable_path/' "$out/lib/"
  '';

  configureFlags = [
    "--enable-optimize"
    "--disable-debug"
  ] ++ stdenv.lib.optional stdenv.is64bit "--enable-64bit";

  postInstall = ''
    find $out -name "*.a" -delete
    moveToOutput share "$dev" # just aclocal
  '';

  buildInputs = [] ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.mozilla.org/projects/nspr/;
    description = "Netscape Portable Runtime, a platform-neutral API for system-level and libc-like functions";
    platforms = stdenv.lib.platforms.all;
  };
}
