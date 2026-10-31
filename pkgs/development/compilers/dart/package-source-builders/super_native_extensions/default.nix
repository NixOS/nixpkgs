{
  lib,
  rustPlatform,
  pkg-config,
  at-spi2-atk,
  gdk-pixbuf,
  cairo,
  gtk3,
  writeText,
  stdenv,
}:

{ version, src, ... }:

let
  rustDep = rustPlatform.buildRustPackage {
    pname = "super_native_extensions-rs";
    inherit version src;

    unpackPhase = ''
      runHook preUnpack

      cp -r $src/${src.passthru.packageRoot} ${src.name}
      chmod -R u+w -- "$sourceRoot"

      runHook postUnpack
    '';

    sourceRoot = "${src.name}/rust";

    cargoHash =
      rec {
        _0_10_0-dev_2 = "sha256-PbmAtRQpUJjWTsIVao87ywNCAGiZCB2Np6Ig7yh6c5Y=";
        _0_9_1 = _0_9_0-dev_6;
        _0_9_0-dev_6 = "sha256-1yJIbBxScmkCwy/e+/z2cYA8qQBfT0yoIBmOSPVd4h4=";
        _0_9_0-dev_5 = _0_8_22;
        _0_9_0-dev_3 = _0_8_22;
        _0_8_22 = "sha256-gYYoC3bGJrYY1uUHfqMv6pp4SK+P9fRoBsLtf34rsCg=";
        _0_8_24 = _0_8_22;
        _0_8_21 = _0_8_22;
        _0_8_20 = _0_8_22;
        _0_8_19 = _0_8_22;
        _0_8_18 = _0_8_22;
        _0_8_17 = _0_8_22;
      }
      .${"_" + (lib.replaceStrings [ "." ] [ "_" ] version)} or (throw ''
        Unsupported version of pub 'super_native_extensions': '${version}'
        Please add cargoHash to here. If the cargoHash
        is the same with existing versions, add an alias here.
      '');

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [
      at-spi2-atk
      gdk-pixbuf
      cairo
      gtk3
    ];

    passthru.libraryPath =
      if lib.versionAtLeast (lib.versions.majorMinor version) "0.10" then
        "lib/libsuper_native_extensions_native.so"
      else
        "lib/libsuper_native_extensions.so";
  };

  fakeCargokitCmake = writeText "FakeCargokit.cmake" ''
    function(apply_cargokit target manifest_dir lib_name any_symbol_name)
      target_link_libraries("''${target}" PRIVATE ${rustDep}/${rustDep.passthru.libraryPath})
      set("''${target}_cargokit_lib" ${rustDep}/${rustDep.passthru.libraryPath} PARENT_SCOPE)
    endfunction()
  '';

in
stdenv.mkDerivation {
  pname = "super_native_extensions";
  inherit version src;
  inherit (src) passthru;

  postPatch = ''
    pushd ${src.passthru.packageRoot}
  ''
  + (
    if lib.versionAtLeast (lib.versions.majorMinor version) "0.10" then
      ''
        substitute ${./build.dart} hook/build.dart \
          --replace-fail "@rust-lib@" "${rustDep}/${rustDep.passthru.libraryPath}"
      ''
    else
      ''
        chmod +rwx cargokit/cmake/cargokit.cmake
        cp ${fakeCargokitCmake} cargokit/cmake/cargokit.cmake
      ''
  )
  + ''
    popd
  '';

  installPhase = ''
    runHook preInstall

    cp -r . "$out"

    runHook postInstall
  '';
}
