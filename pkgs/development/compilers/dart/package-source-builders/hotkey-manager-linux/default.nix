{
  stdenv,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "hotkey-manager-linux";
  inherit version src;
  inherit (src) passthru;

  prePatch = ''
    # from a package like multipass, we get a src with the root hotkey_manager repo and need to cd into the linux package to apply the patch
    # but from a package like wox, we get a src with the linux package already, I'm not sure why
    if [[ -d packages/hotkey_manager_linux ]]; then
      WAS_ROOT_DIRECTORY=1
      pushd packages/hotkey_manager_linux
    fi
  '';

  patches = [
    ./0001-fix-build-failure-with-Clang-21.patch
  ];

  postPatch = ''
    if [[ WAS_ROOT_DIRECTORY -eq 1 ]]; then
      popd
    fi
  '';

  patchFlags = [ "-p3" ];

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
}
