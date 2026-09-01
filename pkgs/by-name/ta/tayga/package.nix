{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tayga";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "apalrd";
    repo = "tayga";
    tag = finalAttrs.version;
    hash = "sha256-OsF2RqZzDvf8FMLHN6YAKvWfFgAIQfVkbBTC8hjf2dU=";
  };

  patches = [
    # nat64.c: call inet_ntop with properly sized buffers
    # https://github.com/apalrd/tayga/pull/168
    (fetchpatch2 {
      url = "https://github.com/apalrd/tayga/commit/b41bd030846451d72b277854678b58370b1d5c8f.patch?full_index=1";
      hash = "sha256-vFQTlZs9ghxdx4k/iODDOUBAglyll1OxUdTjzDtcwB0=";
    })
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  installFlags = [
    "WITH_SYSTEMD=1"
    "sbindir=${placeholder "out"}/bin"
    "sysconfdir=${placeholder "out"}/etc"
    "servicedir=${placeholder "out"}/lib/systemd/system"
  ];

  postInstall = ''
    substituteInPlace "$out/lib/systemd/system/tayga@.service" \
      --replace-fail "ExecSearchPath=/usr/local/sbin:/usr/sbin" "" \
      --replace-fail "ExecStart=tayga" "ExecStart=$out/bin/tayga"
  '';

  env = lib.optionalAttrs stdenv.hostPlatform.is32bit {
    NIX_CFLAGS_COMPILE = "-D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64";
  };

  passthru.tests.tayga = nixosTests.tayga;

  doCheck = true;

  meta = {
    description = "Userland stateless NAT64 daemon";
    longDescription = ''
      TAYGA is an out-of-kernel stateless NAT64 implementation
      for Linux that uses the TUN driver to exchange IPv4 and
      IPv6 packets with the kernel.
      It is intended to provide production-quality NAT64 service
      for networks where dedicated NAT64 hardware would be overkill.
    '';
    homepage = "https://github.com/apalrd/tayga";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    platforms = lib.platforms.linux;
    mainProgram = "tayga";
  };
})
