{ stdenv, fetchurl, makeWrapper, cacert, zlib, buildRustPackage, curl, darwin
, version
, src
, platform
, versionType
}:

let
  inherit (stdenv.lib) getLib optionalString;
  inherit (darwin) libiconv;
  inherit (darwin.apple_sdk.frameworks) Security;

  bootstrapping = versionType == "bootstrap";

  patchBootstrapCargo = ''
    ${optionalString (stdenv.isLinux && bootstrapping) ''
      patchelf \
        --set-rpath "${stdenv.lib.makeLibraryPath [ curl zlib ]}" \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        "$out/bin/cargo"
    ''}
    ${optionalString (stdenv.isDarwin && bootstrapping) ''
      install_name_tool \
        -change /usr/lib/libiconv.2.dylib '${getLib libiconv}/lib/libiconv.2.dylib' \
        "$out/bin/cargo"
      install_name_tool \
        -change /usr/lib/libcurl.4.dylib '${getLib curl}/lib/libcurl.4.dylib' \
        "$out/bin/cargo"
      install_name_tool \
        -change /usr/lib/libz.1.dylib '${getLib zlib}/lib/libz.1.dylib' \
        "$out/bin/cargo"
    ''}
  '';

  installComponents
    = "rustc,rust-std-${platform}"
    + (optionalString bootstrapping ",rust-docs,cargo")
    ;
in

rec {
  inherit buildRustPackage;

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

    phases = ["unpackPhase" "installPhase" "fixupPhase"];

    propagatedBuildInputs = stdenv.lib.optional stdenv.isDarwin Security;

    installPhase = ''
      ./install.sh --prefix=$out \
        --components=${installComponents}

      ${optionalString (stdenv.isLinux && bootstrapping) ''
        patchelf \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          "$out/bin/rustc"
        patchelf \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          "$out/bin/rustdoc"
      ''}

      ${patchBootstrapCargo}

      # Do NOT, I repeat, DO NOT use `wrapProgram` on $out/bin/rustc
      # (or similar) here. It causes strange effects where rustc loads
      # the wrong libraries in a bootstrap-build causing failures that
      # are very hard to track dow. For details, see
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

    phases = ["unpackPhase" "installPhase" "fixupPhase"];

    buildInputs = [ makeWrapper ];
    propagatedBuildInputs = stdenv.lib.optional stdenv.isDarwin Security;

    installPhase = ''
      ./install.sh --prefix=$out \
        --components=cargo

      ${patchBootstrapCargo}

      wrapProgram "$out/bin/cargo" \
        --suffix PATH : "${rustc}/bin"
    '';
  };
}
