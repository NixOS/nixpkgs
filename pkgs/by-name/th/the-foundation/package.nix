{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  pkg-config,
  curl,
  libunistring,
  openssl,
  pcre2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "the-foundation";
  version = "1.14.0";

  src = fetchFromCodeberg {
    owner = "skyjake";
    repo = "the_Foundation";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XUb96wpq7h+Lf+iFgg/AEEKV71N0Z9Ibrfut6Q/dnbc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    libunistring
    openssl
    pcre2
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeFeature "UNISTRING_DIR" "${libunistring}")
  ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/the_Foundation.pc \
      --replace-fail '="''${prefix}//' '="/'
  '';

  meta = {
    description = "Opinionated C11 library for low-level functionality";
    homepage = "https://codeberg.org/skyjake/the_Foundation";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
