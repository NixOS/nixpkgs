{ lib, stdenv, makeWrapper, bash, curl, darwin, zlib
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
  rustc = stdenv.mkDerivation {
    pname = "rustc-${versionType}";

    inherit version;
    inherit src;

    meta = with lib; {
      homepage = "http://www.rust-lang.org/";
      description = "A safe, concurrent, practical language";
      maintainers = with maintainers; [ qknight ];
      license = [ licenses.mit licenses.asl20 ];
    };

    buildInputs = [ bash ]
      ++ lib.optional stdenv.isDarwin Security;

    postPatch = ''
      patchShebangs .
    '';

    installPhase = ''
      ./install.sh --prefix=$out \
        --components=${installComponents}

      ${optionalString (stdenv.isLinux && bootstrapping) (''
        patchelf \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          "$out/bin/rustc"
        '' + optionalString (lib.versionAtLeast version "1.46")
        # rustc bootstrap needs libz starting from 1.46
        ''
          ln -s ${zlib}/lib/libz.so.1 $out/lib/libz.so.1
          ln -s ${zlib}/lib/libz.so $out/lib/libz.so
        '' + ''
        patchelf \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          "$out/bin/rustdoc"
        patchelf \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          "$out/bin/cargo"
      '')}

      # Do NOT, I repeat, DO NOT use `wrapProgram` on $out/bin/rustc
      # (or similar) here. It causes strange effects where rustc loads
      # the wrong libraries in a bootstrap-build causing failures that
      # are very hard to track down. For details, see
      # https://github.com/rust-lang/rust/issues/34722#issuecomment-232164943
    '';

    setupHooks = ./setup-hook.sh;
  };

  cargo = stdenv.mkDerivation {
    pname = "cargo-${versionType}";

    inherit version;
    inherit src;

    meta = with lib; {
      homepage = "http://www.rust-lang.org/";
      description = "A safe, concurrent, practical language";
      maintainers = with maintainers; [ qknight ];
      license = [ licenses.mit licenses.asl20 ];
    };

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ bash ] ++ lib.optional stdenv.isDarwin Security;

    postPatch = ''
      patchShebangs .
    '';

    installPhase = ''
      patchShebangs ./install.sh
      ./install.sh --prefix=$out \
        --components=cargo

      ${optionalString (stdenv.isLinux && bootstrapping) ''
        patchelf \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          "$out/bin/cargo"
      ''}

      wrapProgram "$out/bin/cargo" \
        --suffix PATH : "${rustc}/bin"
    '';
  };
}
