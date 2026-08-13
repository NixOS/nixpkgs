{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xlslib";
  version = "2.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/xlslib/xlslib-package-${finalAttrs.version}.zip";
    sha256 = "1wx3jbpkz2rvgs45x6mwawamd1b2llb0vn29b5sr0rfxzx9d1985";
  };

  nativeBuildInputs = [
    unzip
    autoreconfHook
  ];

  setSourceRoot = "export sourceRoot=xlslib/xlslib";

  enableParallelBuilding = true;

  meta = {
    description = "C++/C library to construct Excel .xls files in code";
    homepage = "https://sourceforge.net/projects/xlslib/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
