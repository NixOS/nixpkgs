{ stdenv, makeWrapper, bash, curl, darwin
, version
, src
, platform
, versionType
}:

let
  inherit (stdenv.lib) optionalString;
  inherit (darwin.apple_sdk.frameworks) Security;

  bootstrapping = versionType == "bootstrap";

  installComponents
    = "rustc,rust-std-${platform}"
    + (optionalString bootstrapping ",cargo")
    ;
in

rec {
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

    buildInputs = [ bash ] ++ stdenv.lib.optional stdenv.isDarwin Security;

    postPatch = ''
      patchShebangs .
    '';

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
        patchelf \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          "$out/bin/cargo"
      ''}

      ${optionalString (stdenv.isDarwin && bootstrapping) ''
        install_name_tool -change /usr/lib/libresolv.9.dylib '${darwin.libresolv}/lib/libresolv.9.dylib' "$out/bin/rustc"
        install_name_tool -change /usr/lib/libresolv.9.dylib '${darwin.libresolv}/lib/libresolv.9.dylib' "$out/bin/rustdoc"
        install_name_tool -change /usr/lib/libiconv.2.dylib '${darwin.libiconv}/lib/libiconv.2.dylib' "$out/bin/cargo"
        install_name_tool -change /usr/lib/libresolv.9.dylib '${darwin.libresolv}/lib/libresolv.9.dylib' "$out/bin/cargo"
        install_name_tool -change /usr/lib/libcurl.4.dylib '${stdenv.lib.getLib curl}/lib/libcurl.4.dylib' "$out/bin/cargo"
        for f in $out/lib/lib*.dylib; do
          install_name_tool -change /usr/lib/libresolv.9.dylib '${darwin.libresolv}/lib/libresolv.9.dylib' "$f"
        done
      ''}

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

    buildInputs = [ makeWrapper bash ] ++ stdenv.lib.optional stdenv.isDarwin Security;

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

      ${optionalString (stdenv.isDarwin && bootstrapping) ''
        install_name_tool -change /usr/lib/libiconv.2.dylib '${darwin.libiconv}/lib/libiconv.2.dylib' "$out/bin/cargo"
        install_name_tool -change /usr/lib/libresolv.9.dylib '${darwin.libresolv}/lib/libresolv.9.dylib' "$out/bin/cargo"
        install_name_tool -change /usr/lib/libcurl.4.dylib '${stdenv.lib.getLib curl}/lib/libcurl.4.dylib' "$out/bin/cargo"
      ''}

      wrapProgram "$out/bin/cargo" \
        --suffix PATH : "${rustc}/bin"
    '';
  };
}
