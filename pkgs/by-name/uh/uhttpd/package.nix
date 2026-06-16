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
  version = "0-unstable-2026-06-16";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uhttpd.git";
    rev = "7b1bec45826bd78c8afc993435bdc0f1df2fe399";
    hash = "sha256-XjM+BBUmZ4bkp8qMH6fBDm7f6whVHiw1RrAZPPnL5CY=";
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
