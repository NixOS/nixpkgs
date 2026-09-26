import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

const _assetName = 'libpdfium';
const _linuxPdfium = '@pdfium-binaries@/lib/libpdfium.so';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;
    if (input.config.code.targetOS == OS.iOS) return;

    final target = _PdfiumTarget.fromCodeConfig(input.config.code);
    final outputFile = input.outputDirectory.resolve(target.libraryFileName);

    if (target.targetOS == OS.linux) {
      final source = File(_linuxPdfium);
      if (!await source.exists()) {
        throw Exception('nixpkgs PDFium library not found at $_linuxPdfium');
      }
      await File.fromUri(outputFile).parent.create(recursive: true);
      await File.fromUri(outputFile).writeAsBytes(await source.readAsBytes());
    } else {
      throw UnsupportedError('pdfium_dart is patched for linux-only offline builds in nixpkgs');
    }

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

final class _PdfiumTarget {
  const _PdfiumTarget({required this.targetOS, required this.libraryFileName});

  final OS targetOS;
  final String libraryFileName;

  static _PdfiumTarget fromCodeConfig(CodeConfig config) {
    return switch (config.targetOS) {
      OS.linux => const _PdfiumTarget(targetOS: OS.linux, libraryFileName: 'libpdfium.so'),
      OS.android => const _PdfiumTarget(targetOS: OS.android, libraryFileName: 'libpdfium.so'),
      OS.windows => const _PdfiumTarget(targetOS: OS.windows, libraryFileName: 'pdfium.dll'),
      OS.macOS => const _PdfiumTarget(targetOS: OS.macOS, libraryFileName: 'libpdfium.dylib'),
      _ => throw UnsupportedError('Unsupported PDFium platform'),
    };
  }
}
