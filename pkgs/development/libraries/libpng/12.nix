{ lib, stdenv, fetchurl, zlib }:

assert stdenv.hostPlatform == stdenv.buildPlatform -> zlib != null;

stdenv.mkDerivation rec {
  pname = "libpng";
  version = "1.2.59";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    sha256 = "1izw9ybm27llk8531w6h4jp4rk2rxy2s9vil16nwik5dp0amyqxl";
  };

  outputs = [ "out" "dev" "man" ];

  propagatedBuildInputs = [ zlib ];

  passthru = { inherit zlib; };

  configureFlags = [ "--enable-static" ];

  postInstall = ''mv "$out/bin" "$dev/bin"'';

  meta = with lib; {
    description = "The official reference implementation for the PNG file format";
    homepage = "http://www.libpng.org/pub/png/libpng.html";
    license = licenses.libpng;
    maintainers = [ ];
    branch = "1.2";
    platforms = platforms.unix;
  };
}
