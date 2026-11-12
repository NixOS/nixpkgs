{
  lib,
  stdenv,
  fetchgit,
  cmake,
  pkg-config,
  lua5_1,
  json_c,
  libubox,
  ubus,
  libxcrypt,
  unstableGitUpdater,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uhttpd";
  version = "0-unstable-2026-10-19";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uhttpd.git";
    rev = "ca796d7dec5697a2d1a7a42be79677f239b64282";
    hash = "sha256-jt1VLq+561y1k8uyChUwT2/TA/1iZYK8GgPi+i+5dUU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    lua5_1
    json_c
    libubox
    ubus
    libxcrypt
  ];

  cmakeFlags = [
    "-DUCODE_SUPPORT=off"
    "-DTLS_SUPPORT=on"
    "-DLUA_SUPPORT=on"
  ];

  env.NIX_LDFLAGS = "-lcrypt";

  postInstall = ''
    wrapProgram $out/bin/uhttpd \
      --prefix LD_LIBRARY_PATH : $out/lib/uhttpd
  '';

  passthru.updateScript = unstableGitUpdater {
    branch = "master";
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Tiny HTTP server from OpenWrt project";
    homepage = "https://openwrt.org/docs/guide-user/services/webserver/uhttpd";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "uhttpd";
  };
})
