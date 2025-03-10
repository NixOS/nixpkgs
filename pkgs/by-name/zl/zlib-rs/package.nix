{
  cmake,
  fetchFromGitHub,
  lib,
  nix-update-script,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "zlib-rs";
  version = "0.4.2-unstable-2025-03-04";

  src = fetchFromGitHub {
    owner = "trifectatechfoundation";
    repo = "zlib-rs";
    rev = "034e5f063ddd73cd8a511e4ad256e4e11552c4ff";
    hash = "sha256-BDzrS4ZGavIKyLHXv2dZGpZYtXOZ6Gu/CP0LhetkcCg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-z7O3EiL6yx/2WHY1XGpfgUacMN/xFf5HTWkOPwxWRcg=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  supportedPlatform =
    with stdenv.hostPlatform;
    lib.concatStringsSep "-" [
      (if isx86_64 then "x86_64" else "aarch64")
      (if isLinux then "unknown-linux-gnu" else "apple-darwin")
    ];

  installPhase = ''
    runHook preInstall

    install -Dm644 target/$supportedPlatform/release/*.rlib -t $out/lib

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust implementation of the zlib file format that is compatible with the zlib API";
    homepage = "https://github.com/trifectatechfoundation/zlib-rs";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ KSJ2000 ];
    platforms = lib.platforms.unix;
  };
}
