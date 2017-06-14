{ stdenv, fetchurl
, CoreServices ? null }:

let version = "4.15"; in

stdenv.mkDerivation {
  name = "nspr-${version}";

  src = fetchurl {
    url = "mirror://mozilla/nspr/releases/v${version}/src/nspr-${version}.tar.gz";
    sha256 = "101dksqm1z0hzd7ap82ccbxjr48s6q3xhshdl81qkj6hqdmy1p97";
  };

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

  buildInputs = [] ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.mozilla.org/projects/nspr/;
    description = "Netscape Portable Runtime, a platform-neutral API for system-level and libc-like functions";
    platforms = stdenv.lib.platforms.all;
  };
}
