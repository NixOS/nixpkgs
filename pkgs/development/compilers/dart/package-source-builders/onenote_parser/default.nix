{
  lib,
  rustPlatform,
  stdenvNoCC,
  writeText,
}:

{ version, src, ... }:

let
  rustDep = rustPlatform.buildRustPackage {
    pname = "onenote_parser-rs";
    inherit version src;

    sourceRoot = "${src.name}/${src.passthru.packageRoot}/rust";

    cargoHash =
      {
        _0_0_1 = "sha256-bM+WAuUIWQIj7n/yqWrSRkeXsH8U3ek2jSsFvR6WWrc=";
      }
      .${"_" + (lib.replaceStrings [ "." ] [ "_" ] version)} or (throw ''
        Unsupported version of pub 'onenote_parser': '${version}'
        Please add cargoHash here. If the cargoHash
        is the same with existing versions, add an alias here.
      '');
  };
in
stdenvNoCC.mkDerivation {
  pname = "onenote_parser";
  inherit version src;
  inherit (src) passthru;

  setupHook = writeText "onenote_parser-setup-hook" ''
    onenoteParserFixupHook() {
      runtimeDependencies+=('${rustDep}')
    }

    preFixupHooks+=(onenoteParserFixupHook)
  '';

  postPatch = ''
    cp ${(writeText "build.dart" ''
      import 'package:hooks/hooks.dart';

      void main(List<String> args) async {
        await build(args, (input, output) async {});
      }
    '')} ${src.passthru.packageRoot}/hook/build.dart
  '';

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
}
