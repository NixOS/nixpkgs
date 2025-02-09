{ lib, stdenv, fetchurl, zlib
, testers
}:

assert stdenv.hostPlatform == stdenv.buildPlatform -> zlib != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "libpng";
  version = "1.2.59";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${finalAttrs.version}.tar.xz";
    sha256 = "1izw9ybm27llk8531w6h4jp4rk2rxy2s9vil16nwik5dp0amyqxl";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace pngconf.h --replace-fail '<fp.h>' '<math.h>'
  '';

  outputs = [ "out" "dev" "man" ];

  propagatedBuildInputs = [ zlib ];

  configureFlags = [ "--enable-static" ];

  postInstall = ''mv "$out/bin" "$dev/bin"'';

  passthru = {
    inherit zlib;

    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Official reference implementation for the PNG file format";
    homepage = "http://www.libpng.org/pub/png/libpng.html";
    license = licenses.libpng;
    maintainers = [ ];
    branch = "1.2";
    pkgConfigModules = [ "libpng" "libpng12" ];
    platforms = platforms.unix;
  };
})
