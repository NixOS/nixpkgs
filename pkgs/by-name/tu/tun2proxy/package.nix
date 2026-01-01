{
  lib,
<<<<<<< HEAD
  stdenv,
  rustPlatform,
  fetchCrate,
  rust-cbindgen,
=======
  rustPlatform,
  fetchCrate,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tun2proxy";
<<<<<<< HEAD
  version = "0.7.19";
=======
  version = "0.7.16";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchCrate {
    pname = "tun2proxy";
    inherit (finalAttrs) version;
<<<<<<< HEAD
    hash = "sha256-mg1GGtWCjxSPhlb0pjFNPVTblZWfUXQa3643T9siD20=";
  };

  cargoHash = "sha256-ZoLy3iknPUq2OmXQUomVVWij+mexixB6eDvGhrlsWDk=";

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

=======
    hash = "sha256-VO0dxX2FVKFSW157HYJxvlc2Xe6W+npw+4ls/1ePu80=";
  };

  cargoHash = "sha256-CWaHHKuDr731cf3tms4Sg9NvCjW0TgmxG3vO37z/UrE=";

  env.GIT_HASH = "000000000000000000000000000000000000000000000000000";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    homepage = "https://github.com/tun2proxy/tun2proxy";
    description = "Tunnel (TUN) interface for SOCKS and HTTP proxies";
    changelog = "https://github.com/tun2proxy/tun2proxy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "tun2proxy-bin";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
})
