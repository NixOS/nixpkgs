{
  stdenv,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "hotkey_manager_linux";
  inherit version src;
  inherit (src) passthru;

  postPatch = ''
    pushd ${src.passthru.packageRoot}
    substituteInPlace linux/hotkey_manager_linux_plugin.cc \
      --replace-fail "const char* identifier;" "const char* identifier = nullptr;" \
      --replace-fail "const char* keystring;" "const char* keystring = nullptr;"
    popd
  '';

  installPhase = ''
    runHook preInstall

    cp --recursive . "$out"

    runHook postInstall
  '';
}
