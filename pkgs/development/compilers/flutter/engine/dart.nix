{ engine, runCommand }:
runCommand "flutter-engine-${engine.version}-dart"
  {
    version = engine.dartSdkVersion;

    meta = engine.meta // {
      description = "Dart SDK compiled from the Flutter Engine";
    };
  }
  ''
    ln --symbolic ${engine}/out/${engine.outName}/dart-sdk $out
  ''
