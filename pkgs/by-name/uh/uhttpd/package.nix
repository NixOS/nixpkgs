{
  lib,
  stdenv,
  fetchgit,
  cmake,
  pkg-config,
  lua5_1,
  json_c,
  libubox-wolfssl,
  ubus,
  libxcrypt,
  unstableGitUpdater,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uhttpd";
  version = "0-unstable-2026-04-16";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uhttpd.git";
    rev = "e619cb04cddba8316d6928ff99f55a49e6ddc561";
    hash = "sha256-2BOdmfumntZ9xZyEYCJ3FhC0GbLEGq0eVCu95IRFkdc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    lua5_1
    json_c
    libubox-wolfssl
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
