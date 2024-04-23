{ callPackage }:

{
  flutter_secure_storage_linux = callPackage ./flutter-secure-storage-linux { };
  handy_window = callPackage ./handy-window { };
  matrix = callPackage ./matrix { };
  media_kit_libs_linux = callPackage ./media_kit_libs_linux { };
  olm = callPackage ./olm { };
  sqlite3 = callPackage ./sqlite3 { };
  system_tray = callPackage ./system-tray { };
}
