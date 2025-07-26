{ callPackage }:

{
  audiotags = callPackage ./audiotags { };
  file_picker = callPackage ./file_picker { };
  flutter_discord_rpc = callPackage ./flutter_discord_rpc { };
  flutter_secure_storage_linux = callPackage ./flutter-secure-storage-linux { };
  flutter_vodozemac = callPackage ./flutter_vodozemac { };
  flutter_volume_controller = callPackage ./flutter_volume_controller { };
  handy_window = callPackage ./handy-window { };
  matrix = callPackage ./matrix { };
  media_kit_libs_linux = callPackage ./media_kit_libs_linux { };
  metadata_god = callPackage ./metadata_god { };
  objectbox_flutter_libs = callPackage ./objectbox_flutter_libs { };
  olm = callPackage ./olm { };
  pdfrx = callPackage ./pdfrx { };
  printing = callPackage ./printing { };
  rhttp = callPackage ./rhttp { };
  sentry_flutter = callPackage ./sentry_flutter { };
  sqlcipher_flutter_libs = callPackage ./sqlcipher_flutter_libs { };
  sqlite3 = callPackage ./sqlite3 { };
  sqlite3_flutter_libs = callPackage ./sqlite3_flutter_libs { };
  super_native_extensions = callPackage ./super_native_extensions { };
  system_tray = callPackage ./system_tray { };
  volume_controller = callPackage ./volume_controller { };
  xdg_directories = callPackage ./xdg_directories { };
}
