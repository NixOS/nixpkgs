{ engine, runCommand }:
runCommand "flutter-engine-${engine.version}-dart"
  {
    version = engine.dartSdkVersion;

    inherit engine;
    inherit (engine) outName;

    meta = engine.meta // {
      description = "Dart SDK compiled from the Flutter Engine";
    };
  }
  ''
    ln -s ${engine}/out/$outName/dart-sdk $out
  ''
