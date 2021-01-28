{ lib
, stdenv
, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "google-fonts";
  version = "unstable-2021-01-19";

  outputs = [ "out" "adobeBlank" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "a3a831f0fe44cd58465c6937ea06873728f2ba0d";
    sha256 = "19abx2bj7mkysv2ihr43m3kpyf6kv6v2qjlm1skxc82rb72xqhix";
  };

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

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
