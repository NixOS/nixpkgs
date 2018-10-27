{ stdenv, fetchurl, autoreconfHook, buildPackages
, CoreServices ? null }:

let version = "4.20"; in

stdenv.mkDerivation {
  name = "nspr-${version}";

  src = fetchurl {
    url = "mirror://mozilla/nspr/releases/v${version}/src/nspr-${version}.tar.gz";
    sha256 = "0vjms4j75zvv5b2siyafg7hh924ysx2cwjad8spzp7x87n8n929c";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev";
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  preConfigure = ''
    cd nspr
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace '@executable_path/' "$out/lib/"
    substituteInPlace configure.in --replace '@executable_path/' "$out/lib/"
  '';

  preAutoreconf = ''
    cd nspr
  '';

  postAutoreconf = "cd ..";

  # NSPR uses a non-standard host/build/target convention
  configureFlags = [
    "--enable-optimize"
    "--disable-debug"
    "--host=${stdenv.buildPlatform.config}"
    "--build=${stdenv.hostPlatform.config}"
    "--target=${stdenv.targetPlatform.config}"
  ] ++ stdenv.lib.optional stdenv.is64bit "--enable-64bit";

  configurePlatforms = [];

  postInstall = ''
    find $out -name "*.a" -delete
    moveToOutput share "$dev" # just aclocal
  '';

  buildInputs = [] ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];
  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.mozilla.org/projects/nspr/;
    description = "Netscape Portable Runtime, a platform-neutral API for system-level and libc-like functions";
    platforms = stdenv.lib.platforms.all;
  };
}
