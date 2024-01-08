{ lib
, fetchurl
, fetchpatch
, stdenv
, cmake
, dos2unix
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "wineditline";
  version = "2.206";

  src = fetchurl {
    url = "mirror://sourceforge/mingweditline/wineditline-${version}.tar.bz2";
    hash = "sha256-NzP1FEPb3jprvn0MbHY+beTGBclfBL1WnuP0RzyyG3E=";
  };

  prePatch = ''
    find . -type f -exec dos2unix {} \;
  '';

  patches = [
    (fetchpatch {
      name = "001-fix-installing.patch";
      url = "https://github.com/msys2/MINGW-packages/raw/9c315e395cab2fc7c9188ee8879f91a9dcec98e6/mingw-w64-wineditline/001-fix-installing.patch";
      hash = "sha256-gh0KNhFYMqdkl9xtfqS25F5M5zYhAwpZhl+FEwn42zQ=";
    })
    (fetchpatch {
      name = "002-fix-exports.patch";
      url = "https://github.com/msys2/MINGW-packages/raw/a27ed41197add64cea95e521edbf86b27d78df7c/mingw-w64-wineditline/002-fix-exports.patch";
      hash = "sha256-OOd5+96/LykDi1mJIOczpKUWOINAE8PMc/uFp9UM/9I=";
    })
    (fetchpatch {
      name = "003-dont-link-with-def.patch";
      url = "https://github.com/msys2/MINGW-packages/raw/29ed2670ffe210ee56f4ef1a6cabecaa43747d27/mingw-w64-wineditline/003-dont-link-with-def.patch";
      hash = "sha256-GQd3JnWN53gM1o8/R9g1NRb9hk7eGQPVUoCh+z2+QI0=";
    })
    (fetchpatch {
      name = "004-add-pkgconfig.patch";
      url = "https://github.com/msys2/MINGW-packages/raw/6409528ef7f6fd9df8691bdcef8524420a4a5915/mingw-w64-wineditline/004-add-pkgconfig.patch";
      hash = "sha256-PoEFsuWiCVApFw5BWjcXPInzMzcsjfEpJwRTV0LftPw=";
    })
  ];

  postPatch = ''
    substituteInPlace src/fn_complete.c \
      --replace "Strsafe.h" "strsafe.h"
  '';

  nativeBuildInputs = [
    cmake
    dos2unix
    pkg-config
  ];

  meta = with lib; {
    description = "An EditLine API implementation for the native Windows Console";
    homepage = "https://sourceforge.net/projects/mingweditline/";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.windows;
  };
}
