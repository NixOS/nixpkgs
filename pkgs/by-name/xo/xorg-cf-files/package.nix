{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xorg-cf-files";
  version = "1.0.8";

  src = fetchurl {
    url = "mirror://xorg/individual/util/xorg-cf-files-${finalAttrs.version}.tar.xz";
    hash = "sha256-dAiVXe/Pqw9E0b7dTsDCDbYZFJF60Xv8Hxyb9WrMF7k=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace $out/lib/X11/config/darwin.cf --replace "/usr/bin/" ""
  '';

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/util/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Xorg imake configuration files";
    homepage = "https://gitlab.freedesktop.org/xorg/util/cf";
    license = with lib.licenses; [
      icu
      x11
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
