{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  wrapWithXFileSearchPathHook,
  xorgproto,
  libxaw,
  libxt,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xmore";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xmore-${finalAttrs.version}.tar.xz";
    hash = "sha256-frVg28HeTkPGT+SRrXOQeinXNMyoKprYLH0/65zbCpo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapWithXFileSearchPathHook
  ];

  buildInputs = [
    xorgproto
    libxaw
    libxt
  ];

  installFlags = [ "appdefaultdir=$(out)/share/X11/app-defaults" ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/app/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Plain text display program for the X Window System";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xmore";
    license = with lib.licenses; [
      hpndSellVariant
      mitOpenGroup
    ];
    mainProgram = "xmore";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
