{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  twemoji-color-font,
  imagemagick,
  inkscape,
  nodePackages,
  potrace,
  scfbuild,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "twemoji-color-font";
  version = "15.1.0";

  src = fetchFromGitHub {
    owner = "13rac1";
    repo = "twemoji-color-font";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Nx6zyj6FLFFyWz0vbbN3eYk2WRns7IVG6lDvLOmSf6E=";
  };

  nativeBuildInputs = [
    imagemagick
    inkscape
    nodePackages.svgo
    potrace
    scfbuild
    which
  ];

  # silence inkscape errors about non-writable home
  preBuild = "export HOME=\"$NIX_BUILD_ROOT\"";
  buildFlags = [
    "SCFBUILD=${scfbuild}/bin/scfbuild"
    "linux-package"
  ];
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 build/TwitterColorEmoji-SVGinOT.ttf $out/share/fonts/truetype/TwitterColorEmoji-SVGinOT.ttf
    install -Dm644 linux/fontconfig/46-twemoji-color.conf $out/etc/fonts/conf.d/46-twemoji-color.conf
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    inherit (twemoji-color-font.meta)
      description
      longDescription
      homepage
      downloadPage
      license
      ;
    maintainers = [ lib.maintainers.ncfavier ];
    hydraPlatforms = [ ]; # https://github.com/NixOS/nixpkgs/issues/97871
  };
})
