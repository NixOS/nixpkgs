{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, expat
, fontconfig
, freetype
, libidn
, libjpeg
, libpng
, libtiff
, libxml2
, lua5
, openssl
, pkg-config
, zlib
, catch2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "podofo";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "podofo";
    repo = "podofo";
    rev = finalAttrs.version;
    hash = "sha256-W61ufT/YT8DLVpGM2ai7ZFE6mR+vassyK8Ool/nAfU4=";
    fetchSubmodules = true;  # includes test data
  };

  prePatch = ''
    # remove any possibility it may try to use these
    rm -r extern/deps
  '';

  patches = [
    (fetchpatch {
      name = "CVE-2023-2241.patch";
      url = "https://github.com/podofo/podofo/commit/535a786f124b739e3c857529cecc29e4eeb79778.patch";
      hash = "sha256-c2Ae9eOxSvKzzoyOZw4j5xBjj6SM5gmfq2dwnpbgMBg=";
    })
    (fetchpatch {
      name = "CVE-2023-31555.patch";
      url = "https://github.com/podofo/podofo/commit/3759eb6aae7c01f2d8670f16ac46f5e116c7f468.patch";
      hash = "sha256-r726T58TEPwEicM+DFgOliIvyzDqYwlQNCd0z6P0cZI=";
    })
    (fetchpatch {
      name = "CVE-2023-31556.part-1.patch";
      url = "https://github.com/podofo/podofo/commit/657c46c1e192b23f6903a5c57f52b7bdc2c597ef.patch";
      hash = "sha256-VGZ5vgjBtzFcLR+Oi90/2iXgHpwvpTt1yXGKBXNoqps=";
    })
    (fetchpatch {
      name = "CVE-2023-31556.part-2.patch";
      url = "https://github.com/podofo/podofo/commit/8d3e9104ea10f8b53a0b5a2a806e6388acd41a40.patch";
      hash = "sha256-UHfRiBzNcJdkcDE5iXi0wN78YfGiUyMqpqXDDpItRaE=";
    })
    (fetchpatch {
      name = "CVE-2023-31568.patch";
      url = "https://github.com/podofo/podofo/commit/29d59f604b37159e938a2f46acd4856cfd1e7bac.patch";
      hash = "sha256-Pwm5jyNYiDyzZaPMejl9REQXu588q3fatNZv0JVuE9E=";
    })
  ];

  outputs = [ "out" "dev" "lib" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    expat
    fontconfig
    freetype
    libidn
    libjpeg
    libpng
    libtiff
    libxml2
    lua5
    openssl
    zlib
  ];

  cmakeFlags = [
    "-DPODOFO_BUILD_STATIC=${if stdenv.hostPlatform.isStatic then "ON" else "OFF"}"
    "-DPODOFO_BUILD_TEST=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
  ];

  postInstall = ''
    moveToOutput lib "$lib"
  '';

  doCheck = true;
  nativeCheckInputs = [ catch2 ];

  meta = {
    homepage = "https://github.com/podofo/podofo";
    description = "A library to work with the PDF file format";
    platforms = lib.platforms.all;
    license = with lib.licenses; [ gpl2Plus lgpl2Plus ];
    maintainers = [];
  };
})
