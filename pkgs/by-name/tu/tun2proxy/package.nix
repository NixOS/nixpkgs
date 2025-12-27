{
  lib,
  stdenv,
  rustPlatform,
  fetchCrate,
  rust-cbindgen,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tun2proxy";
  version = "0.7.18";

  src = fetchCrate {
    pname = "tun2proxy";
    inherit (finalAttrs) version;
    hash = "sha256-abgknJuP0p5QS2iTyix0Uq6xiQkeTGK+M/weIHoZNgI=";
  };

  cargoHash = "sha256-8DGlQCXXrq5s0TkqpWhgb2Gw1ve8LCxT0KNzZLvd0zY=";

  env.GIT_HASH = "000000000000000000000000000000000000000000000000000";

  nativeBuildInputs = [ rust-cbindgen ];

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  postBuild = ''
    cbindgen --config cbindgen.toml -o target/tun2proxy.h
  '';

  installPhase = ''
    runHook preInstall

    install -D target/${stdenv.hostPlatform.rust.rustcTarget}/release/tun2proxy-bin -t $out/bin
    install -D target/${stdenv.hostPlatform.rust.rustcTarget}/release/udpgw-server -t $out/bin

    install -D target/tun2proxy.h -t $dev/include

    install -D target/${stdenv.hostPlatform.rust.rustcTarget}/release/libtun2proxy.a -t $lib/lib
    install -D target/${stdenv.hostPlatform.rust.rustcTarget}/release/libtun2proxy${stdenv.hostPlatform.extensions.library} -t $lib/lib

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/tun2proxy/tun2proxy";
    description = "Tunnel (TUN) interface for SOCKS and HTTP proxies";
    changelog = "https://github.com/tun2proxy/tun2proxy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "tun2proxy-bin";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
})
