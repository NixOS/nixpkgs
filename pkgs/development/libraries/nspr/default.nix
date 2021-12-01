{ lib
, stdenv
, fetchurl
, CoreServices
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "nspr";
  version = "4.32";

  src = fetchurl {
    url = "mirror://mozilla/nspr/releases/v${version}/src/nspr-${version}.tar.gz";
    sha256 = "0v3zds1id71j5a5si42a658fjz8nv2f6zp6w4gqrqmdr6ksz8sxv";
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

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/Reference/NSPR_functions";
    description = "Netscape Portable Runtime, a platform-neutral API for system-level and libc-like functions";
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
    license = licenses.mpl20;
  };
}
