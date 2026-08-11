{
  lib,
  stdenv,
  fetchurl,
  perl,
  bdftopcf,
  bdf2psf,
  imagemagick,
}:

let
  perlenv = perl.withPackages (ps: [ ps.GD ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "unifont";
  version = "17.0.05";

  strictDeps = true;

  src = fetchurl {
    url = "mirror://gnu/unifont/unifont-${finalAttrs.version}/unifont-${finalAttrs.version}.tar.gz";
    hash = "sha256-8ofP+ybiJyOqNuZoSGmw8/87+4IsSwEAi9hHkR7BtjE=";
  };

  postPatch = ''
    rm -r font/precompiled
    patchShebangs ./src
  '';

  nativeBuildInputs = [
    perlenv
    bdftopcf
    bdf2psf
    imagemagick
  ];

  buildInputs = [
    perlenv
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  buildFlags = [ "BUILDFONT=1" ];

  postInstall = ''
    moveToOutput bin "$bin"
    moveToOutput share/unifont "$doc"
  '';

  outputs = [
    "out"
    "bin"
    "doc"
    "man"
    "info"
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Unicode font for Base Multilingual Plane";
    homepage = "https://unifoundry.com/unifont/";

    # Basically GPL2+ with font exception.
    license = with lib.licenses; [
      gpl2Plus
      fontException
    ];
    maintainers = with lib.maintainers; [
      rycee
      qweered
    ];
    platforms = lib.platforms.all;
  };
})
