{
  lib,
  stdenv,
  fetchFromGitea,
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
  version = "1.13.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "skyjake";
    repo = "the_Foundation";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j8AeJdCjGxjsy6R+MFuWqXfYEFISfQqg2SlqiRx6G/k=";
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
    homepage = "https://git.skyjake.fi/skyjake/the_Foundation";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
