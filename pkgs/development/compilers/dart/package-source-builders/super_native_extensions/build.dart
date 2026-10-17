import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

const _assetName = 'super_native_extensions_native';
const _rustLib = '@rust-lib@';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;

    final fileName = switch (input.config.code.targetOS) {
      OS.windows => 'super_native_extensions_native.dll',
      OS.macOS || OS.iOS => 'libsuper_native_extensions_native.dylib',
      _ => 'libsuper_native_extensions_native.so',
    };
    final outputFile = input.outputDirectory.resolve(fileName);

    final source = File(_rustLib);
    if (!await source.exists()) {
      throw Exception(
        'nixpkgs super_native_extensions rust library not found at $_rustLib',
      );
    }
    await File.fromUri(outputFile).parent.create(recursive: true);
    await File.fromUri(outputFile).writeAsBytes(await source.readAsBytes());

    output.assets.code.add(
      CodeAsset(
        package: input.packageName,
        name: _assetName,
        linkMode: DynamicLoadingBundled(),
        file: outputFile,
      ),
    );
  });
}
