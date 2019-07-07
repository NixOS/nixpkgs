{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "google-fonts-${version}";
  version = "2018-07-13";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "3ca591dae7372a26e254ec6d22e7b453813b9530";
    sha256 = "01ak3dzw2kihwa0dy27x8vvpiscd66mnkf61vj1xn29m4g48y0lr";
  };

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1pzm26794nwdbsvjnczpfchxiqa1n1zhp517g6g39wfm1nfszz83";

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  patchPhase = ''
    # These directories need to be removed because they contain
    # older or duplicate versions of fonts also present in other
    # directories. This causes non-determinism in the install since
    # the installation order of font files with the same name is not
    # fixed.
    rm -rv ofl/alefhebrew \
      ofl/misssaintdelafield \
      ofl/mrbedford \
      ofl/siamreap \
      ofl/terminaldosislight

    if find . -name "*.ttf" | sed 's|.*/||' | sort | uniq -c | sort -n | grep -v '^.*1 '; then
      echo "error: duplicate font names"
      exit 1
    fi
  '';

  installPhase = ''
    dest=$out/share/fonts/truetype
    find . -name '*.ttf' -exec install -m 444 -Dt $dest '{}' +
  '';

  meta = with stdenv.lib; {
    homepage = https://fonts.google.com;
    description = "Font files available from Google Fonts";
    license = with licenses; [ asl20 ofl ufl ];
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = with maintainers; [ manveru ];
  };
}
