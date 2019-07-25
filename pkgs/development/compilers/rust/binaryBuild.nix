{ stdenv, makeWrapper, bash, curl, darwin
, version
, src
, platform
, versionType
, autoPatchelfHook
}:

let
  inherit (darwin.apple_sdk.frameworks) Security;
in rec {
  rustc = stdenv.mkDerivation rec {
    name = "rustc-${versionType}-${version}";

    inherit version;
    inherit src;

    meta = with stdenv.lib; {
      homepage = http://www.rust-lang.org/;
      description = "A safe, concurrent, practical language";
      maintainers = with maintainers; [ qknight ];
      license = [ licenses.mit licenses.asl20 ];
    };

    buildInputs = [ bash ]
      ++ stdenv.lib.optional stdenv.isDarwin Security;

    nativeBuildInputs = stdenv.lib.optional (!stdenv.isDarwin) autoPatchelfHook;

    postPatch = ''
      patchShebangs .
    '';

    installPhase = ''
      ./install.sh --prefix=$out \
        --components=rustc,rust-std-${platform},${stdenv.lib.optionalString (versionType == "bootstrap") ",cargo"}

      # Do NOT, I repeat, DO NOT use `wrapProgram` on $out/bin/rustc
      # (or similar) here. It causes strange effects where rustc loads
      # the wrong libraries in a bootstrap-build causing failures that
      # are very hard to track down. For details, see
      # https://github.com/rust-lang/rust/issues/34722#issuecomment-232164943
    '';
  };

  cargo = stdenv.mkDerivation rec {
    name = "cargo-${versionType}-${version}";

    inherit version;
    inherit src;

    meta = with stdenv.lib; {
      homepage = http://www.rust-lang.org/;
      description = "A safe, concurrent, practical language";
      maintainers = with maintainers; [ qknight ];
      license = [ licenses.mit licenses.asl20 ];
    };

    buildInputs = [ makeWrapper bash ]
      ++ stdenv.lib.optional stdenv.isDarwin Security;

    nativeBuildInputs = stdenv.lib.optional (!stdenv.isDarwin) autoPatchelfHook;

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
