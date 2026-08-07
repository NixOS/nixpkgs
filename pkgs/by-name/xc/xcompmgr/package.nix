{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrender,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xcompmgr";
  version = "1.1.10";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xcompmgr-${finalAttrs.version}.tar.xz";
    hash = "sha256-eCT3CcTyJDLq6nVC7JM4Tl3Uj2/LhcEv+C1yFCOwuY8=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrender
  ];

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
    description = "Sample X11 compositing manager";
    longDescription = ''
      xcompmgr is a sample compositing manager for X servers supporting the XFIXES, DAMAGE, RENDER
      and COMPOSITE extensions. It enables basic eye-candy effects.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xcompmgr";
    license = lib.licenses.hpndSellVariant;
    mainProgram = "xcompmgr";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
