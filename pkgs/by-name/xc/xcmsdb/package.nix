{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libx11,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xcmsdb";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xcmsdb-${finalAttrs.version}.tar.xz";
    hash = "sha256-XsQGjkiBh7BeqS7hNiyWt4qQ8ZzMehhExZIdcGJrvDg=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libx11 ];

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
    description = "Device Color Characterization utility for X Color Management System";
    longDescription = ''
      xcmsdb is used to load, query, or remove Device Color Characterization data stored in
      properties on the root window of the screen as specified in section 7, Device Color
      Characterization, of the X11 Inter-Client Communication Conventions Manual (ICCCM).
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xcmsdb";
    license = with lib.licenses; [
      hpnd
      mitOpenGroup
    ];
    mainProgram = "xcmsdb";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
