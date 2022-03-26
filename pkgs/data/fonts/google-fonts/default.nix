{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "google-fonts";
  version = "unstable-2022-02-26";

  outputs = [ "out" "adobeBlank" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "2fba0d68602b7eb3374d030c1c34939de56023f9";
    sha256 = "sha256-IFkKwRRyZeOXD8/9n8UDrruUKK6oQK4BD9wYN2dmSAc=";
  };

  patchPhase = ''
    # These directories need to be removed because they contain
    # older or duplicate versions of fonts also present in other
    # directories. This causes non-determinism in the install since
    # the installation order of font files with the same name is not
    # fixed.
    rm -rv ofl/cabincondensed \
           ofl/signikanegative \
           ofl/signikanegativesc

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
