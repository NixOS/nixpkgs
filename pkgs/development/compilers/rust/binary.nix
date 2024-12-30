{ lib, stdenv, makeWrapper, wrapRustc, bash, curl, darwin, zlib
, autoPatchelfHook, gcc
, version
, src
, platform
, versionType
}:

let
  inherit (lib) optionalString;
  inherit (darwin.apple_sdk.frameworks) Security;

  bootstrapping = versionType == "bootstrap";

  installComponents
    = "rustc,rust-std-${platform}"
    + (optionalString bootstrapping ",cargo")
    ;
in

rec {
  rustc-unwrapped = stdenv.mkDerivation {
    pname = "rustc-${versionType}";

    inherit version;
    inherit src;

    meta = with lib; {
      homepage = "https://www.rust-lang.org/";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      description = "A safe, concurrent, practical language";
      maintainers = with maintainers; [ qknight ];
      license = [ licenses.mit licenses.asl20 ];
    };

    nativeBuildInputs = lib.optional (!stdenv.isDarwin) autoPatchelfHook;
    buildInputs = [ bash ]
      ++ lib.optionals (!stdenv.isDarwin) [ gcc.cc.lib zlib ]
      ++ lib.optional stdenv.isDarwin Security;

    postPatch = ''
      patchShebangs .
    '';

    installPhase = ''
      ./install.sh --prefix=$out \
        --components=${installComponents}

      # Do NOT, I repeat, DO NOT use `wrapProgram` on $out/bin/rustc
      # (or similar) here. It causes strange effects where rustc loads
      # the wrong libraries in a bootstrap-build causing failures that
      # are very hard to track down. For details, see
      # https://github.com/rust-lang/rust/issues/34722#issuecomment-232164943
    '';

    # The strip tool in cctools 973.0.1 and up appears to break rlibs in the
    # binaries. The lib.rmeta object inside the ar archive should contain an
    # .rmeta section, but it is removed. Luckily, this doesn't appear to be an
    # issue for Rust builds produced by Nix.
    dontStrip = true;

    setupHooks = ./setup-hook.sh;
  };

  rustc = wrapRustc rustc-unwrapped;

  cargo = stdenv.mkDerivation {
    pname = "cargo-${versionType}";

    inherit version;
    inherit src;

    meta = with lib; {
      homepage = "https://doc.rust-lang.org/cargo/";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      description = "The Rust package manager";
      maintainers = with maintainers; [ qknight ];
      license = [ licenses.mit licenses.asl20 ];
    };

    nativeBuildInputs = [ makeWrapper ]
      ++ lib.optional (!stdenv.isDarwin) autoPatchelfHook;
    buildInputs = [ bash ]
      ++ lib.optional (!stdenv.isDarwin) gcc.cc.lib
      ++ lib.optional stdenv.isDarwin Security;

    postPatch = ''
      patchShebangs .
    '';

    installPhase = ''
      patchShebangs ./install.sh
      ./install.sh --prefix=$out \
        --components=cargo

      wrapProgram "$out/bin/cargo" \
        --suffix PATH : "${rustc}/bin"
    '';
  };
}
