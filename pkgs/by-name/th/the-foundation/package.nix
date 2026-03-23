{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  pkg-config,
  curl,
  libunistring,
  openssl,
  pcre,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "the-foundation";
  version = "1.12.0";

  src = fetchFromGitea {
    domain = "git.skyjake.fi";
    owner = "skyjake";
    repo = "the_Foundation";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dAeeeu0nWS/Tz4/t/s9xKcx2io5FGooHhWiK12GHJpQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    libunistring
    openssl
    pcre
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeFeature "UNISTRING_DIR" "${libunistring}")
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=attribute-warning";

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/the_Foundation.pc \
      --replace '="''${prefix}//' '="/'
  '';

  meta = {
    description = "Opinionated C11 library for low-level functionality";
    homepage = "https://git.skyjake.fi/skyjake/the_Foundation";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
