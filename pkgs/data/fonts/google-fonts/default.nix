{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "google-fonts-${version}";
  version = "2016-08-30";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "7a4070f65f2ca85ffdf2d465ff5e095005bae197";
    sha256 = "0c20vcsd0jki8drrim68z2ca0cxli4wyh1i1gyg4iyac0a0v8wx3";
  };

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "13n2icpdp1z7i14rnfwkjdydhbjgdvyl1crd71hfy6l1j2p3kzyf";

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
