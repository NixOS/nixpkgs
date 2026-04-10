{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xorg-docs";
  version = "1.7.3";

  src = fetchurl {
    url = "mirror://xorg/individual/doc/xorg-docs-${finalAttrs.version}.tar.xz";
    hash = "sha256-KKLy7rXZ/1i4WWH/Pte6qvH/oTLiqB+LK7l8tJm83e8=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  # This makes the man pages discoverable by the default man,
  # since it looks for packages in $PATH
  postInstall = "mkdir $out/bin";

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/doc/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Documentation for the X Window System";
    homepage = "https://gitlab.freedesktop.org/xorg/doc/xorg-docs";
    license = with lib.licenses; [
      # The project does not provide a top-level license or copying file, so I scoured the whole
      # codebase (which is quite small, fortunately) to find all licenses.
      # There is a licensing file at general/Licenses.xml.
      mit
      icu
      x11
      hpndSellVariant
      hpnd
      bsd3
      bsdOriginalUC
      bsd3ClauseTso
      bsd2
      isc
      sgi-b-20
      # Luxi fonts license is listed in general/Licenses.xml.
      # However, since there is no font is in the repo, this license is not added here.
      # There is a high chance that some of the other licenses are not used in xorg-docs either
      # but there is no way to find out.

      # repo contains the X logo, which was converted from Xmu/DrawLogo.c, licensed under:
      mitOpenGroup
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
