{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  libusb1,
  libedit,
  curl,
  gengetopt,
  pkg-config,
  pcsclite,
  help2man,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "yubihsm-shell";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubihsm-shell";
    rev = version;
    hash = "sha256-ymGS35kjhNlFee3FEXF8n6Jm7NVaynjv+lpix6F75BQ=";
  };

  postPatch = ''
    # Can't find libyubihsm at runtime because of dlopen() in C code
    substituteInPlace lib/yubihsm.c \
      --replace "libyubihsm_usb.so" "$out/lib/libyubihsm_usb.so" \
      --replace "libyubihsm_http.so" "$out/lib/libyubihsm_http.so"
    # ld: unknown option: -z
    substituteInPlace CMakeLists.txt cmake/SecurityFlags.cmake \
      --replace "AppleClang" "Clang"
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    help2man
    gengetopt
  ];

  buildInputs = [
    libusb1
    libedit
    curl
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pcsclite.dev
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  preBuild = lib.optionalString stdenv.hostPlatform.isLinux ''
    NIX_CFLAGS_COMPILE="$(pkg-config --cflags libpcsclite) $NIX_CFLAGS_COMPILE"
  '';

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  meta = with lib; {
    description = "Thin wrapper around libyubihsm providing both an interactive and command-line interface to a YubiHSM";
    homepage = "https://github.com/Yubico/yubihsm-shell";
    maintainers = with maintainers; [ matthewcroughan ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
