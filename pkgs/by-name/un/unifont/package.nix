{
  lib,
  stdenv,
  bashNonInteractive,
  buildPackages,
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
    ${lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      substituteInPlace Makefile --replace-fail \
        'bin/unigenwidth ' \
        '$(BINDIR)/unigenwidth '
      substituteInPlace font/Makefile --replace-fail \
        '"BINDIR:../../../$(BINDIR)/"' \
        '"BINDIR:$(BINDIR)/"'
    ''}
  '';

  nativeBuildInputs = [
    perlenv
    bdftopcf
    bdf2psf
    imagemagick
  ];

  buildInputs = [
    bashNonInteractive
    perlenv
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "BINDIR=${buildPackages.unifont.bin}/bin"
  ];

  buildFlags = [ "BUILDFONT=1" ];

  postInstall = ''
    moveToOutput bin "$bin"
    moveToOutput share/unifont "$doc"
  '';

  postFixup = ''
    patchShebangs --host --update "$bin"
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
