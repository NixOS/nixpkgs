{ callPackage }:

{
  file_picker = callPackage ./file_picker { };
  flutter_secure_storage_linux = callPackage ./flutter-secure-storage-linux { };
  flutter_volume_controller = callPackage ./flutter_volume_controller { };
  fvp = callPackage ./fvp { };
  handy_window = callPackage ./handy-window { };
  matrix = callPackage ./matrix { };
  media_kit_libs_linux = callPackage ./media_kit_libs_linux { };
  olm = callPackage ./olm { };
  pdfrx = callPackage ./pdfrx { };
  printing = callPackage ./printing { };
  rhttp = callPackage ./rhttp { };
  sqlcipher_flutter_libs = callPackage ./sqlcipher_flutter_libs { };
  sqlite3 = callPackage ./sqlite3 { };
  sqlite3_flutter_libs = callPackage ./sqlite3_flutter_libs { };
  system_tray = callPackage ./system-tray { };
  super_native_extensions = callPackage ./super_native_extensions { };
  xdg_directories = callPackage ./xdg_directories { };
}
