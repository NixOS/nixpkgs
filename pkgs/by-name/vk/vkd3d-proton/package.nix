{
  lib,
  callPackage,
  glslang,
  meson,
  ninja,
  pkgsCross,
  stdenv,
  wine,
}:

let
  sources = callPackage ./sources.nix { };

  # `stdenv'` is an explicit parameter (rather than pulling the mingw one via
  # pkgsCross.mingwW64.callPackage) so that nativeBuildInputs like `wine`
  # (needed for widl) stay bound to their plain build-platform derivation
  # instead of going through Nix's cross-splicing, which currently crashes
  # resolving wine's `wine32 = pkgsi686Linux.callPackage ...` under the mingw
  # target combination.
  mkVkd3dProton =
    stdenv':
    let
      isWindows = stdenv'.hostPlatform.isWindows;
    in
    stdenv'.mkDerivation (
      {
        inherit (sources.vkd3d-proton) pname version src;

        outputs = [
          "out"
          "dev"
        ];

        nativeBuildInputs = [
          glslang
          meson
          ninja
          wine
        ];

        buildInputs = lib.optionals isWindows [ pkgsCross.mingwW64.windows.pthreads ];

        strictDeps = true;

        postPatch = ''
          substituteInPlace meson.build \
            --replace-fail "vkd3d_build = vcs_tag(" \
                           "vkd3d_build = vcs_tag( fallback : '$(cat .nixpkgs-auxfiles/vkd3d_build)'", \
            --replace-fail "vkd3d_version = vcs_tag(" \
                           "vkd3d_version = vcs_tag( fallback : '$(cat .nixpkgs-auxfiles/vkd3d_version)'",
        '';

        passthru = {
          inherit sources;
        }
        // lib.optionalAttrs (!isWindows) {
          # Real d3d12.dll / d3d12core.dll PE binaries, built in release mode.
          dll = mkVkd3dProton pkgsCross.mingwW64.stdenv;
        };

        meta = {
          homepage = "https://github.com/HansKristian-Work/vkd3d-proton";
          description = "Fork of VKD3D, which aims to implement the full Direct3D 12 API on top of Vulkan";
          license = lib.licenses.lgpl21Plus;
          maintainers = with lib.maintainers; [ borgvall ];
          platforms = if isWindows then lib.platforms.windows else wine.meta.platforms;
        };
      }
      // lib.optionalAttrs isWindows {
        mesonBuildType = "release";
      }
    );
in
mkVkd3dProton stdenv
