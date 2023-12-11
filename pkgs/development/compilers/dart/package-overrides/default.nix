{ callPackage }:

{
  flutter_secure_storage_linux = callPackage ./flutter-secure-storage-linux { };
  handy_window = callPackage ./handy-window { };
  matrix = callPackage ./matrix { };
  olm = callPackage ./olm { };
  system_tray = callPackage ./system-tray { };
}
