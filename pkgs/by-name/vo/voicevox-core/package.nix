{
  lib,
  stdenv,
<<<<<<< HEAD
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
  version = "0.16.2";
  modelVersion = "0.16.1";

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
    version = finalAttrs.modelVersion;

    src = fetchFromGitHub {
      owner = "VOICEVOX";
      repo = "voicevox_vvm";
      tag = finalAttrs.modelVersion;
      hash = "sha256-OY+xuvNjgmH/bxhL61XJZ3JVOxyec6kifkoGD4eN7HA=";
    };

    nativeBuildInputs = [ python3 ];

    installPhase = ''
      runHook preInstall

      # convert multipart zip archive into single file
      python scripts/merge_vvm.py
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

=======
  fetchurl,
  unzip,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "voicevox-core";
  version = "0.15.9";

  src = finalAttrs.passthru.sources.${stdenv.hostPlatform.system};

  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    install -Dm755 libonnxruntime.* libvoicevox_core.* -t $out/lib
    install -Dm644 model/* -t $out/lib/model
    install -Dm644 *.h -t $out/include
    install -Dm644 README.txt -t $out/share/doc/voicevox-core

    runHook postInstall
  '';

  # When updating, run the following command to fetch all FODs:
  # nix-build -A voicevox-core.sources --keep-going
  passthru.sources =
    let
      # Note: Only the prebuilt binaries are able to decrypt the encrypted voice models
      fetchCoreArtifact =
        { id, hash }:
        fetchurl {
          url = "https://github.com/VOICEVOX/voicevox_core/releases/download/${finalAttrs.version}/voicevox_core-${id}-cpu-${finalAttrs.version}.zip";
          inherit hash;
        };
    in
    {
      "x86_64-linux" = fetchCoreArtifact {
        id = "linux-x64";
        hash = "sha256-dEikEQcGL6h59nTxY833XGBawUjceq8NxIUVhRdQ2I8=";
      };
      "aarch64-linux" = fetchCoreArtifact {
        id = "linux-arm64";
        hash = "sha256-92aZEb2bz7xXA4uSo3lWy/cApr88I+yNqDlAWo6nFpg=";
      };
      "x86_64-darwin" = fetchCoreArtifact {
        id = "osx-x64";
        hash = "sha256-/5MghfgI8wup+o+eYMgcjI9Mjkjt1NPuN0x3JnqAlxg=";
      };
      "aarch64-darwin" = fetchCoreArtifact {
        id = "osx-arm64";
        hash = "sha256-UrgI4dy/VQCLZ/gyMX0D0YPabtw3IA76CpjLmbFLQeY=";
      };
    };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    changelog = "https://github.com/VOICEVOX/voicevox_core/releases/tag/${finalAttrs.version}";
    description = "Core library for the VOICEVOX speech synthesis software";
    homepage = "https://github.com/VOICEVOX/voicevox_core";
<<<<<<< HEAD
    license = with lib.licenses; [ mit ];
=======
    license = with lib.licenses; [
      mit
      {
        name = "VOICEVOX Core Library Terms of Use";
        url = "https://github.com/VOICEVOX/voicevox_resource/blob/main/core/README.md";
        free = false;
        redistributable = true;
      }
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [
      tomasajt
      eljamm
    ];
<<<<<<< HEAD
=======
    platforms = lib.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
