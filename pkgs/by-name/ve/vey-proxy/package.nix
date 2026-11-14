{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  python3,
  capnproto,
  openssl,
  c-ares,
  lua5_5,
  coreutils,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vey-proxy";
  version = "1.15.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "VEY-OSS";
    repo = "vey";
    tag = "vey-proxy-v${finalAttrs.version}";
    hash = "sha256-Ah9dGk80c7SQYe5zf1sak+Kw/gyswuyxxEsZCr99gw8=";
  };

  cargoHash = "sha256-1g33QRzbCkytH62/xImR12DvsX+PiySpRIcK4IG/dHI=";

  # Same codegen as the upstream release-lto profile (inherits release, lto = true).
  # buildType cannot be "release-lto": cargo-build-hook exports
  # CARGO_PROFILE_${buildType}_STRIP, and the hyphen is not a valid identifier.
  env.CARGO_PROFILE_RELEASE_LTO = "true";

  buildFeatures = [
    "secure-snmalloc"
    "lua55"
  ];

  cargoBuildFlags = [
    "-p"
    "vey-proxy"
    "-p"
    "vey-proxy-ctl"
    "-p"
    "vey-proxy-lua"
    "-p"
    "vey-proxy-ftp"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
    capnproto
  ];

  buildInputs = [
    openssl
    c-ares
    lua5_5
  ];

  env.VEY_PACKAGE_VERSION = finalAttrs.version;

  postInstall = ''
    install -D -m 644 vey-proxy/debian/vey-proxy@.service $out/lib/systemd/system/vey-proxy@.service
    substituteInPlace $out/lib/systemd/system/vey-proxy@.service \
      --replace-fail /usr/bin/ $out/bin/ \
      --replace-fail /bin/kill ${coreutils}/bin/kill
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^vey-proxy-v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Forward, reverse, and transparent proxy with TLS interception and policy controls";
    homepage = "https://github.com/VEY-OSS/vey";
    changelog = "https://github.com/VEY-OSS/vey/blob/vey-proxy-v${finalAttrs.version}/vey-proxy/CHANGELOG";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zh-jq ];
    mainProgram = "vey-proxy";
    platforms = lib.platforms.linux;
  };
})
