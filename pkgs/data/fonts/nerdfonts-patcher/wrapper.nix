{ stdenv
, lib
, nerdfonts-patcher-unwrapped
, python3
, fontforge

, fontPackage ? null
, fontName ? null
, glyphFlags ? "-c"
}:

# assert fontPackage != null;
# assert fontName != null;

stdenv.mkDerivation rec {
  pname = toString fontName + "-nerd-font";
  version = "v2.1.0";

  nativeBuildInputs = [
    nerdfonts-patcher-unwrapped
    python3
    fontforge
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p $out/share/fonts
    find ${toString fontPackage}/share/fonts/**/*.{ttf,otf} \
      -exec python ${nerdfonts-patcher-unwrapped}/font-patcher \
      ${glyphFlags} -o $out/share/fonts/ {} \;
    runHook postBuild
  '';

  meta = with lib; {
    description = "Iconic font aggregator, collection, & patcher. 3,600+ icons, 50+ patched fonts";
    longDescription = ''
      Nerd Fonts is a project that attempts to patch as many developer targeted
      and/or used fonts as possible. The patch is to specifically add a high
      number of additional glyphs from popular 'iconic fonts' such as Font
      Awesome, Devicons, Octicons, and others.
    '';
    homepage = "https://nerdfonts.com/";
    license = licenses.mit;
    maintainers = with maintainers; [
      nomisiv
    ];
  };
}
