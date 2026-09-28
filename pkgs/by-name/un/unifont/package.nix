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

  # The `sample` variants are not intended for general use.
  #
  # From the 2013 changelog:
  #
  # > These "Unifont Sample" fonts contain combining circles, and four-digit
  # > hexadecimal glyphs for unassigned code points and Private Use Area glyphs.
  # > Because of the inclusion of combining cirlces, "Unifont Sample" font
  # > versions are only intended for illustrating individual glyphs, not for
  # > general-purpose writing.
  postInstall = ''
    moveToOutput bin "$bin"
    moveToOutput share/unifont "$doc"

    # Move `sample` into its own output.
    mkdir -vp "$sample/share/fonts/X11/misc/"
    mkdir -vp "$sample/share/fonts/opentype/unifont/"
    mv -vt "$sample/share/fonts/X11/misc/" \
      "$out"/share/fonts/X11/misc/*_sample.*
    mv -vt "$sample/share/fonts/opentype/unifont/" \
      "$out"/share/fonts/opentype/unifont/*_sample.*
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
    "sample"
  ];

  # Don't bloat the font output with tools
  propagatedBuildOutputs = [ ];

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
