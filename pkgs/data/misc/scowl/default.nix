{stdenv, fetchFromGitHub, unzip, zip, perl, aspell, dos2unix}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "scowl";
  version = "2017.08.24";

  src = fetchFromGitHub {
    owner = "en-wl";
    repo = "wordlist";
    rev = "rel-${version}";
    sha256 = "16mgk6scbw8i38g63kh60bsnzgzfs8gvvz2n5jh4x5didbwly8nz";
  };

  buildInputs = [];
  nativeBuildInputs = [unzip zip perl aspell dos2unix];

  NIX_CFLAGS_COMPILE = " -Wno-narrowing ";

  preConfigure = ''
    patchShebangs .
    export PERL5LIB="$PERL5LIB''${PERL5LIB:+:}$PWD/varcon"
  '';

  postBuild = ''
    (
    cd scowl/speller
    make aspell
    make hunspell
    )
  '';

  enableParallelBuilding = false;

  installPhase = ''
    eval "$preInstall"

    mkdir -p "$out/share/scowl" 
    mkdir -p "$out/lib" "$out/share/hunspell" "$out/share/myspell" 
    mkdir -p "$out/share/dict"

    cp -r scowl/speller/aspell "$out/lib/aspell"
    cp scowl/speller/*.{aff,dic} "$out/share/hunspell"
    ln -s "$out/share/hunspell" "$out/share/myspell/dicts"

    cp scowl/final/* "$out/share/scowl"

    (
      cd scowl
      for region in american british british_s british_z canadian australian; do
        case $region in
          american)
            regcode=en-us;
            ;;
          british)
            regcode=en-gb-ise;
            ;;
          british_s)
            regcode=en-gb-ise;
            ;;
          british_z)
            regcode=en-gb-ize;
            ;;
          canadian)
            regcode=en-ca;
            ;;
          australian)
            regcode=en-au;
            ;;
        esac
        regcode_var="$regcode"
        if test "$region" = british; then
          regcode_var="en-gb"
        fi

        echo $region $regcode $regcode_sz
        for s in 10 20 30 35 40 50 55 60 70 80 90; do
          ./mk-list $regcode $s > "$out/share/dict/w$region.$s"
          ./mk-list --variants=1 $regcode_var $s > "$out/share/dict/w$region.variants.$s"
          ./mk-list --variants=2 $regcode_var $s > "$out/share/dict/w$region.acceptable.$s"
        done
        ./mk-list $regcode 60 > "$out/share/dict/w$region.txt"
        ./mk-list --variants=1 $regcode_var 60 > "$out/share/dict/w$region.variants.txt"
        ./mk-list --variants=2 $regcode_var 80 > "$out/share/dict/w$region.scrabble.txt"
      done
      ./mk-list --variants=1 en-gb 60 > "$out/share/dict/words.variants.txt"
      ./mk-list --variants=1 en-gb 80 > "$out/share/dict/words.scrabble.txt"
      ./mk-list en-gb-ise 60 > "$out/share/dict/words.txt"
    )

    eval "$postInstall"
  '';

  meta = {
    inherit version;
    description = "Spell checker oriented word lists";
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
    homepage = "http://wordlist.aspell.net/";
  };
}
