{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  python3,
  testers,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xcb-proto";
  version = "1.17.0";

  src = fetchurl {
    url = "mirror://xorg/individual/proto/xcb-proto-${finalAttrs.version}.tar.xz";
    hash = "sha256-LBus0hEPR5n3TebrtxS5TPb4D7ESMWsSGUgP0iViFIw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/proto/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "XML-XCB protocol descriptions used by libxcb for the X11 protocol & extensions";
    homepage = "https://gitlab.freedesktop.org/xorg/proto/xcbproto";
    license = lib.licenses.x11;
    maintainers = [ ];
    pkgConfigModules = [ "xcb-proto" ];
    platforms = lib.platforms.unix;
  };
})
