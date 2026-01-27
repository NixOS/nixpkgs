{
  lib,
  stdenv,
  fetchzip,
  gitUpdater,
  autoPatchelfHook,
}:

let
  version = "0.2025.10.05.bf8e97e";
  url = "https://github.com/verus-lang/verus/releases/download/release/${version}/verus-${version}";
  srcs = {
    "x86_64-linux" = fetchzip {
      url = "${url}-x86-linux.zip";
      hash = "sha256-r+JKbmxzT8ywza695mobk7KsXWg8tA+vgpEdOi13r8U=";
    };
    "x86_64-darwin" = fetchzip {
      url = "${url}-x86-macos.zip";
      hash = "sha256-3VEhlPzs1WvplT33QqgZgX/IBfL8T/nwTlQj0aWx5ug=";
    };
    "aarch64-darwin" = fetchzip {
      url = "${url}-arm64-macos.zip";
      hash = "sha256-aKpC78p54m5Wa+LRYDJthVU7cAOH2Z046VECxYnbqzg=";
    };
    "x86_64-windows" = fetchzip {
      url = "${url}-x86-win.zip";
      hash = "sha256-gwLUvkiWeEqmzV3g77Dbm4bxgo6lpSEYsRQMEQjGfvc=";
    };
  };
in
stdenv.mkDerivation {
  pname = "verus-bin";
  inherit version;

  src =
    srcs.${stdenv.hostPlatform.system}
      or (throw "verus-bin is not supported on ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    stdenv.cc.cc
  ];

  # intended to be used with rustup
  autoPatchelfIgnoreMissingDeps = [ "librustc_driver-*.so" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r $src/* $out/

    mkdir -p $out/bin
    ln -s $out/verus $out/bin/verus
    ln -s $out/cargo-verus $out/bin/cargo-verus
    ln -s $out/rust_verify $out/bin/rust_verify
    ln -s $out/z3 $out/bin/z3

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "release/";
    url = "https://github.com/verus-lang/verus";
  };

  meta = {
    homepage = "https://github.com/verus-lang/verus";
    description = "Verified Rust for low-level systems code";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jakeginesin
      stephen-huan
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "x86_64-windows"
    ];
    mainProgram = "verus";
  };
}
