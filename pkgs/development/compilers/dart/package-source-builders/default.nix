{ callPackage }:

{
  flutter_secure_storage_linux = callPackage ./flutter-secure-storage-linux { };
  handy_window = callPackage ./handy-window { };
  matrix = callPackage ./matrix { };
  media_kit_libs_linux = callPackage ./media_kit_libs_linux { };
  olm = callPackage ./olm { };
  sqlcipher_flutter_libs = callPackage ./sqlcipher_flutter_libs { };
  sqlite3 = callPackage ./sqlite3 { };
  system_tray = callPackage ./system-tray { };
}
