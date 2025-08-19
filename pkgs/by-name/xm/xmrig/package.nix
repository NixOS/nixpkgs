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

stdenv.mkDerivation rec {
  pname = "xmrig";
  version = "6.24.0";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${version}";
    hash = "sha256-AbiTInOMHZ/YOUyl8IMU62ETZtbSTUqaP4vCJKAOCYM=";
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

  meta = with lib; {
    description = "Monero (XMR) CPU miner";
    homepage = "https://github.com/xmrig/xmrig";
    license = licenses.gpl3Plus;
    mainProgram = "xmrig";
    platforms = platforms.unix;
    maintainers = with maintainers; [ kim0 ];
  };
}
