{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "google-fonts";
  version = "unstable-2022-11-14";

  outputs = [ "out" "adobeBlank" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "83e116a566eda04a2469a11ee562cef1d7b33e4f";
    sha256 = "sha256-sSabk+VWkoXj1Nzv9ufgIU/nkfKf4XkZU1SO+j+eSPA=";
  };

  patchPhase = ''
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

  installPhase = ''
    adobeBlankDest=$adobeBlank/share/fonts/truetype
    install -m 444 -Dt $adobeBlankDest ofl/adobeblank/AdobeBlank-Regular.ttf
    rm -r ofl/adobeblank
    dest=$out/share/fonts/truetype
    find . -name '*.ttf' -exec install -m 444 -Dt $dest '{}' +
  '';

  meta = with lib; {
    homepage = "https://fonts.google.com";
    description = "Font files available from Google Fonts";
    license = with licenses; [ asl20 ofl ufl ];
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = with maintainers; [ manveru ];
  };
}
