{
  lib,
  callPackage,
  stdenvNoCC,
}:
let
  pname = "via";
  version = "3.0.0";
  metaCommon = with lib; {
    description = "Yet another keyboard configurator";
    homepage = "https://caniusevia.com/";
    # Upstream claims to be GPL-3 but doesn't release source code
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ emilytrau ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "via";
  };
  x86_64-appimage = callPackage ./build-from-appimage.nix {
    inherit pname version metaCommon;
    sha256 = "sha256-+uTvmrqHK7L5VA/lUHCZZeRYPUrcVA+vjG7venxuHhs=";
  };
  darwin-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    sha256 = "sha256-MPn4EVSo7pwM8Z9PsaPWyppEj3ZRIoRdseGQufWD0Ws=";
  };
in
(if stdenvNoCC.hostPlatform.isDarwin then darwin-dmg else x86_64-appimage).overrideAttrs
  (oldAttrs: {
    passthru = (oldAttrs.passthru or { }) // {
      inherit x86_64-appimage darwin-dmg;
    };
    meta = oldAttrs.meta // {
      platforms = x86_64-appimage.meta.platforms ++ darwin-dmg.meta.platforms;
      mainProgram = "via";
    };
  })
