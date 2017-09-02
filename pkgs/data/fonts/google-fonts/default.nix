{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "google-fonts-${version}";
  version = "2017-06-28";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "b1cb16c0ce2402242e0106d15b0429d1b8075ecc";
    sha256 = "18kyclwipkdv4zxfws87x2l91jwn34vrizw8rmv8lqznnfsjh2lg";
  };

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0n0j2hi1qb2sc6p3v6lpaqb2aq0m9xjmi7apz3hf2nx97rrsam22";

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
    mkdir -p $dest
    find . -name "*.ttf" -exec cp -v {} $dest \;
    chmod -x $dest/*.ttf
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
