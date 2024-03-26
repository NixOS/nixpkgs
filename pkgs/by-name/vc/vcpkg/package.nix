{ fetchFromGitHub
, stdenvNoCC
, lib
, vcpkg-tool
, writeShellScript
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vcpkg";
  version = "2024.03.19";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vcpkg";
    rev = finalAttrs.version;
    hash = "sha256-861r4XsXCyxUVDlSrekZ+g17td+idUN8qJmmTZNDzow=";
  };

  installPhase = let
    # vcpkg needs two directories to write to that is independent of installation directory.
    # Since vcpkg already creates $HOME/.vcpkg/ we use that to create a root where vcpkg can write into.
    vcpkgScript = writeShellScript "vcpkg" ''
      vcpkg_writable_path="$HOME/.vcpkg/root/"

      VCPKG_ROOT="@out@/share/vcpkg" ${vcpkg-tool}/bin/vcpkg \
        --x-downloads-root="$vcpkg_writable_path"/downloads \
        --x-buildtrees-root="$vcpkg_writable_path"/buildtrees \
        --x-packages-root="$vcpkg_writable_path"/packages \
        "$@"
      '';
    in ''
      runHook preInstall

      mkdir -p $out/bin $out/share/vcpkg/scripts/buildsystems
      cp --preserve=mode -r ./{docs,ports,triplets,scripts,.vcpkg-root,versions,LICENSE.txt} $out/share/vcpkg/
      substitute ${vcpkgScript} $out/bin/vcpkg --subst-var-by out $out
      chmod +x $out/bin/vcpkg
      ln -s $out/bin/vcpkg $out/share/vcpkg/vcpkg
      touch $out/share/vcpkg/vcpkg.disable-metrics

      runHook postInstall
    '';

  meta = {
    description = "C++ Library Manager";
    mainProgram = "vcpkg";
    homepage = "https://vcpkg.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guekka gracicot ];
    platforms = lib.platforms.all;
  };
})
