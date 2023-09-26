{ lib
, stdenv
, autoPatchelfHook
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
    "graalvm-ce"
    "makeWrapper"
    "zlib"
    "libxcrypt-legacy"
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
  ] ++ extraBuildInputs;

  unpackPhase = ''
    runHook preUnpack

    mkdir -p "$out"

    # The tarball on Linux has the following directory structure:
    #
    #   graalvm-ce-java11-20.3.0/*
    #
    # while on Darwin it looks like this:
    #
    #   graalvm-ce-java11-20.3.0/Contents/Home/*
    #
    # We therefor use --strip-components=1 vs 3 depending on the platform.
    tar xf "$src" -C "$out" --strip-components=${
      if stdenv.isLinux then "1" else "3"
    }

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
  } // (args.meta or { }));
} // extraArgs)
