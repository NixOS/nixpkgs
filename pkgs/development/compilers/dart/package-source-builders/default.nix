{ callPackage }:

{
  file_picker = callPackage ./file_picker { };
  flutter_discord_rpc = callPackage ./flutter_discord_rpc { };
  flutter_secure_storage_linux = callPackage ./flutter-secure-storage-linux { };
  flutter_vodozemac = callPackage ./flutter_vodozemac { };
  flutter_volume_controller = callPackage ./flutter_volume_controller { };
  handy_window = callPackage ./handy-window { };
  hotkey_manager_linux = callPackage ./hotkey_manager_linux { };
  matrix = callPackage ./matrix { };
  media_kit_libs_linux = callPackage ./media_kit_libs_linux { };
  olm = callPackage ./olm { };
  pdfium_flutter = callPackage ./pdfium_flutter { };
  pdfrx = callPackage ./pdfrx { };
  printing = callPackage ./printing { };
  rhttp = callPackage ./rhttp { };
  sentry_flutter = callPackage ./sentry_flutter { };
  sqlcipher_flutter_libs = callPackage ./sqlcipher_flutter_libs { };
  sqlite3 = callPackage ./sqlite3 { };
  sqlite3_flutter_libs = callPackage ./sqlite3_flutter_libs { };
  system_tray = callPackage ./system-tray { };
  super_native_extensions = callPackage ./super_native_extensions { };
  volume_controller = callPackage ./volume_controller { };
  xdg_directories = callPackage ./xdg_directories { };
}
