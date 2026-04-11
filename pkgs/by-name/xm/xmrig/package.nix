{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libuv,
  libmicrohttpd,
  openssl,
  hwloc,
  kmod,
  donateLevel ? 0,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmrig";
  version = "6.25.0";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${finalAttrs.version}";
    hash = "sha256-X34djxUeSDwopwsipgrdFFFUP+tQ/uCNvupYzbegkEE=";
  };

  patches = [
    ./donate-level.patch
  ];

  postPatch = ''
    substituteAllInPlace src/donate.h
    substituteInPlace cmake/OpenSSL.cmake \
      --replace "set(OPENSSL_USE_STATIC_LIBS TRUE)" "set(OPENSSL_USE_STATIC_LIBS FALSE)"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace src/hw/msr/Msr_linux.cpp \
      --replace "/sbin/modprobe" "${kmod}/bin/modprobe"
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libuv
    libmicrohttpd
    openssl
    hwloc
  ];

  inherit donateLevel;

  installPhase = ''
    runHook preInstall

    install -vD xmrig $out/bin/xmrig

    runHook postInstall
  '';

  # https://github.com/NixOS/nixpkgs/issues/245534
  hardeningDisable = [ "fortify" ];

  meta = {
    description = "Monero (XMR) CPU miner";
    homepage = "https://github.com/xmrig/xmrig";
    license = lib.licenses.gpl3Plus;
    mainProgram = "xmrig";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kim0 ];
  };
})
