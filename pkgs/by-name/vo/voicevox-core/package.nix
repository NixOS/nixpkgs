{
  lib,
  stdenv,
  callPackage,
  runCommand,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  openssl,
}:

let
  openjtalk-src = fetchFromGitHub {
    owner = "VOICEVOX";
    repo = "open_jtalk";
    rev = "1.11"; # this is actually a branch. why?
    hash = "sha256-SBLdQ8D62QgktI8eI6eSNzdYt5PmGo6ZUCKxd01Z8UE=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "voicevox-core";

  # Update only together with voicevox and voicevox-engine
  # nixpkgs-update: no auto update
  version = "0.16.2";
  passthru.modelVersion = "0.16.3";

  src = fetchFromGitHub {
    owner = "VOICEVOX";
    repo = "voicevox_core";
    tag = finalAttrs.version;
    hash = "sha256-aRy9x6IzFDwL4HjhCW705LpkZ13/SJ25h45XbbXciy0=";
  };

  cargoHash = "sha256-8udiXUZGn3ZT7RvmZd/F5tLsCKi5QLPG3pzv7LFyLvQ=";

  postPatch = ''
    cp -r --no-preserve=all ${openjtalk-src} ./openjtalk
    substitute ${./openjtalk.patch} ./openjtalk.patch \
      --replace-fail "@openjtalk_src@" "$(pwd)/openjtalk"
    patch -d $cargoDepsCopy/open_jtalk-sys-* -p1 < ./openjtalk.patch
  '';

  cargoBuildFlags = [ "-p voicevox_core_c_api" ];

  # don't link onnxruntime directly
  buildFeatures = [ "load-onnxruntime" ];

  # setting this to anything disables trying to download onnxruntime
  env.ORT_LIB_LOCATION = "dummy";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ openssl ];

  doCheck = false;

  passthru.voicevox-onnxruntime = callPackage ./onnxruntime.nix { };

  passthru.models = stdenv.mkDerivation {
    pname = "voicevox-models";
    version = finalAttrs.passthru.modelVersion;

    src = fetchFromGitHub {
      owner = "VOICEVOX";
      repo = "voicevox_vvm";
      tag = finalAttrs.passthru.modelVersion;
      hash = "sha256-VqSNEHJV/g9R+4XknRGi/s4C7/uXEGCK5/NC2XwiPcI=";
    };

    nativeBuildInputs = [ python3 ];

    installPhase = ''
      runHook preInstall

      # convert multipart zip archive into single file
      python scripts/merge_vvm.py

      # Exclude VOICEVOX Nemo models similar to upstream's CI, as voicevox-engine doesn't use them
      rm vvms/n*

      mkdir -p "$out"
      cp vvms/* "$out"

      runHook postInstall
    '';
  };

  passthru.wrapped = runCommand "voicevox-core-${finalAttrs.version}-wrapped" { } (
    ''
      mkdir -p "$out"/lib
      cp ${finalAttrs.finalPackage}/lib/* "$out"/lib
      chmod -R +w "$out/lib"
      ln -s ${finalAttrs.passthru.voicevox-onnxruntime}/lib/* "$out"/lib
      ln -s ${finalAttrs.passthru.models} "$out"/lib/model
    ''
    # allow loading sibling onnxruntime library
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --add-rpath '$ORIGIN' "$out"/lib/libvoicevox_core*
    ''
  );

  meta = {
    changelog = "https://github.com/VOICEVOX/voicevox_core/releases/tag/${finalAttrs.version}";
    description = "Core library for the VOICEVOX speech synthesis software";
    homepage = "https://github.com/VOICEVOX/voicevox_core";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      tomasajt
      eljamm
    ];
  };
})
