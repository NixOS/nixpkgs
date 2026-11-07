{
  lib,
  stdenv,
  mdk-sdk,
  targetFlutterPlatform ? null,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "fvp";
  inherit version src;
  inherit (src) passthru;

  postPatch =
    (lib.optionalString stdenv.hostPlatform.isLinux ''
      sed -i 's|.*libc++.so.1.*|${mdk-sdk}/lib/libc++.so.1|' ./linux/CMakeLists.txt
      substituteInPlace ./linux/CMakeLists.txt \
        --replace-fail "fvp_setup_deps()" "include(${mdk-sdk}/lib/cmake/FindMDK.cmake)"
    '')
    + lib.optionalString (targetFlutterPlatform == "macos") ''
      for podspec in darwin/fvp.podspec macos/fvp.podspec; do
        if [ -f "$podspec" ]; then
          sed -i "/s.dependency 'mdk'/d" "$podspec"
          substituteInPlace "$podspec" \
            --replace-fail "s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }" \
              "s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'HEADER_SEARCH_PATHS' => '${mdk-sdk}/include', 'OTHER_LDFLAGS' => '\$(inherited) ${mdk-sdk}/lib/mdk.framework/mdk -Wl,-rpath,${mdk-sdk}/lib' }"
        fi
      done
      substituteInPlace lib/src/lib.dart \
        --replace-fail "name = 'mdk.framework/mdk';" "name = Platform.isMacOS ? '${mdk-sdk}/lib/mdk.framework/mdk' : 'mdk.framework/mdk';"
    '';

  installPhase = ''
    runHook preInstall

    cp -rL . $out

    runHook postInstall
  '';
}
