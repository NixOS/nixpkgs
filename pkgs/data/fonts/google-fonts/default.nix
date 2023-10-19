{ lib
, stdenvNoCC
, fetchFromGitHub
, fonts ? []
}:

stdenvNoCC.mkDerivation {
  pname = "google-fonts";
  version = "unstable-2022-11-14";

  # Adobe Blank is split out in a separate output,
  # because it causes crashes with `libfontconfig`.
  # It has an absurd number of symbols
  outputs = [ "out" "adobeBlank" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "83e116a566eda04a2469a11ee562cef1d7b33e4f";
    sha256 = "sha256-sSabk+VWkoXj1Nzv9ufgIU/nkfKf4XkZU1SO+j+eSPA=";
  };

  postPatch = ''
    # These directories need to be removed because they contain
    # older or duplicate versions of fonts also present in other
    # directories. This causes non-determinism in the install since
    # the installation order of font files with the same name is not
    # fixed.
    rm -rv ofl/cabincondensed \
      ofl/signikanegative \
      ofl/signikanegativesc \
      axisregistry/tests/data

    if find . -name "*.ttf" | sed 's|.*/||' | sort | uniq -c | sort -n | grep -v '^.*1 '; then
      echo "error: duplicate font names"
      exit 1
    fi
  '';

  dontBuild = true;

  # The font files are in the fonts directory and use two naming schemes:
  # FamilyName-StyleName.ttf and FamilyName[param1,param2,...].ttf
  # This installs all fonts if fonts is empty and otherwise only
  # the specified fonts by FamilyName. To do this, it invokes
  # `find` 2 times for every font, anyone is free to do this
  # in a more efficient way.
  fonts = map (font: builtins.replaceStrings [" "] [""] font) fonts;
  installPhase = ''
    adobeBlankDest=$adobeBlank/share/fonts/truetype
    install -m 444 -Dt $adobeBlankDest ofl/adobeblank/AdobeBlank-Regular.ttf
    rm -r ofl/adobeblank
    dest=$out/share/fonts/truetype
  '' + (if fonts == [] then ''
    find . -name '*.ttf' -exec install -m 444 -Dt $dest '{}' +
  '' else ''
    for font in $fonts; do
      find . -name "$font-*.ttf" -exec install -m 444 -Dt $dest '{}' +
      find . -name "$font[*.ttf" -exec install -m 444 -Dt $dest '{}' +
    done
  '');

  meta = with lib; {
    homepage = "https://fonts.google.com";
    description = "Font files available from Google Fonts";
    license = with licenses; [ asl20 ofl ufl ];
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = with maintainers; [ manveru ];
  };
}
