{ lib
, stdenv
, autoPatchelfHook
, darwin
, graalvm-ce
, makeWrapper
, zlib
, libxcrypt-legacy
  # extra params
, product
, extraBuildInputs ? [ ]
, extraNativeBuildInputs ? [ ]
, ...
} @ args:

let
  extraArgs = builtins.removeAttrs args [
    "lib"
    "stdenv"
    "autoPatchelfHook"
    "darwin"
    "graalvm-ce"
    "libxcrypt-legacy"
    "makeWrapper"
    "zlib"
    "product"
    "extraBuildInputs"
    "extraNativeBuildInputs"
    "meta"
  ];
in
stdenv.mkDerivation ({
  pname = product;

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optional stdenv.isLinux autoPatchelfHook
    ++ extraNativeBuildInputs;

  buildInputs = [
    stdenv.cc.cc.lib # libstdc++.so.6
    zlib
    libxcrypt-legacy # libcrypt.so.1 (default is .2 now)
  ]
  ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Foundation
  ++ extraBuildInputs;

  unpackPhase = ''
    runHook preUnpack

    mkdir -p "$out"

    tar xf "$src" -C "$out" --strip-components=1

    # Sanity check
    if [ ! -d "$out/bin" ]; then
      echo "The `bin` is directory missing after extracting the graalvm"
      echo "tarball, please compare the directory structure of the"
      echo "tarball with what happens in the unpackPhase (in particular"
      echo "with regards to the `--strip-components` flag)."
      exit 1
    fi

    runHook postUnpack
  '';

  dontStrip = true;

  passthru = {
    updateScript = [ ./update.sh product ];
  } // (args.passhtru or { });

  meta = ({
    inherit (graalvm-ce.meta) homepage license sourceProvenance maintainers platforms;
    description = "High-Performance Polyglot VM (Product: ${product})";
    mainProgram = "js";
  } // (args.meta or { }));
} // extraArgs)
