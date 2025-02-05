{
  lib,
  stdenvNoCC,
  fetchurl,
  cabextract,
}:

stdenvNoCC.mkDerivation {
  pname = "vista-fonts";
  version = "1";

  src = fetchurl {
    url = "mirror://sourceforge/mscorefonts2/cabs/PowerPointViewer.exe";
    hash = "sha256-xOdTVI0wkv/X3ThJEF4KJtm1oa/kbm5mf+fGiHiTcB8=";
  };

  nativeBuildInputs = [ cabextract ];

  unpackPhase = ''
    runHook preUnpack

    cabextract --lowercase --filter ppviewer.cab $src
    cabextract --lowercase --filter '*.TTF' ppviewer.cab
    cabextract --lowercase --filter '*.TTC' ppviewer.cab

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp *.ttf *.ttc $out/share/fonts/truetype

    # Set up no-op font configs to override any aliases set up by
    # other packages.
    mkdir -p $out/etc/fonts/conf.d
    for name in Calibri Cambria Candara Consolas Constantia Corbel ; do
      substitute ${./no-op.conf} $out/etc/fonts/conf.d/30-''${name,,}.conf \
        --subst-var-by fontname $name
    done

    runHook postInstall
  '';

  meta = {
    description = "Some TrueType fonts from Microsoft Windows Vista (Calibri, Cambria, Candara, Consolas, Constantia, Corbel)";
    homepage = "http://www.microsoft.com/typography/ClearTypeFonts.mspx";
    license = lib.licenses.unfree; # haven't read the EULA, but we probably can't redistribute these files, so...

    # Set a non-zero priority to allow easy overriding of the
    # fontconfig configuration files.
    priority = 5;
  };
}
