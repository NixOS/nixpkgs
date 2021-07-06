{ lib, stdenv, fetchurl
, CoreServices ? null
, buildPackages }:

stdenv.mkDerivation rec {
  pname = "nspr";
  version = "4.31";

  src = fetchurl {
    url = "mirror://mozilla/nspr/releases/v${version}/src/nspr-${version}.tar.gz";
    sha256 = "1j5b2m8cjlhnnv8sq34587avaagkqvh521w4f95miwgvsn3xlaap";
  };

  patches = [
    ./0001-Makefile-use-SOURCE_DATE_EPOCH-for-reproducibility.patch
  ];

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  preConfigure = ''
    cd nspr
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace '@executable_path/' "$out/lib/"
    substituteInPlace configure.in --replace '@executable_path/' "$out/lib/"
  '';

  HOST_CC = "cc";
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  configureFlags = [
    "--enable-optimize"
    "--disable-debug"
  ] ++ lib.optional stdenv.is64bit "--enable-64bit";

  postInstall = ''
    find $out -name "*.a" -delete
    moveToOutput share "$dev" # just aclocal
  '';

  buildInputs = [] ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.mozilla.org/projects/nspr/";
    description = "Netscape Portable Runtime, a platform-neutral API for system-level and libc-like functions";
    platforms = platforms.all;
    license = licenses.mpl20;
  };
}
