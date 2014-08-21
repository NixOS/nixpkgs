{ stdenv }:

stdenv.mkDerivation {
  name = "libunwind-native";

  unpackPhase = ":";
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib
    cat ${/usr/lib/system/libunwind.dylib} > $out/lib/libunwind.dylib
    /usr/bin/install_name_tool \
      -change /usr/lib/system/libunwind.dylib ${/usr/lib/system/libunwind.dylib} \
      -change /usr/lib/system/libsystem_malloc.dylib ${/usr/lib/system/libsystem_malloc.dylib} \
      -change /usr/lib/system/libsystem_pthread.dylib ${/usr/lib/system/libsystem_pthread.dylib} \
      -change /usr/lib/system/libsystem_platform.dylib ${/usr/lib/system/libsystem_platform.dylib} \
      -change /usr/lib/system/libsystem_c.dylib ${/usr/lib/system/libsystem_c.dylib} \
      -change /usr/lib/system/libdyld.dylib ${/usr/lib/system/libdyld.dylib} \
      -change /usr/lib/system/libkeymgr.dylib ${/usr/lib/system/libkeymgr.dylib} \
      $out/lib/libunwind.dylib
  '';
}
