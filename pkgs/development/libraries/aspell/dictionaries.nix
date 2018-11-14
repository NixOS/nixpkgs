{lib, stdenv, fetchurl, aspell, which}:

with lib;

/* HOWTO:

   * Add some of these to your profile or systemPackages.

     ~~~~
     environment.systemPackages = [
       aspell
       aspellDicts.en
       aspellDicts.en-computers
       aspellDicts.en-science
     ];
     ~~~~

   * Rebuild and switch to the new profile.
   * Add something like

     ~~~~
     master en_US
     extra-dicts en-computers.rws
     add-extra-dicts en_US-science.rws
     ~~~~

     to `/etc/aspell.conf` or `~/.aspell.conf`.
   * Check that `aspell -a` starts without errors.
   * (optional) Check your config with `aspell dump config | grep -vE '^(#|$)'`.
   * Enjoy.

*/

let

  /* Function to compile an Aspell dictionary.  Fortunately, they all
     build in the exact same way. */
  buildDict =
    {shortName, fullName, ...}@args:

    stdenv.mkDerivation ({
      name = "aspell-dict-${shortName}";

      buildInputs = [aspell which];

      dontAddPrefix = true;

      preBuild = "makeFlagsArray=(dictdir=$out/lib/aspell datadir=$out/lib/aspell)";

      meta = {
        description = "Aspell dictionary for ${fullName}";
        platforms = stdenv.lib.platforms.all;
      } // (args.meta or {});
    } // removeAttrs args [ "meta" ]);

  /* Function to compile txt dict files into Aspell dictionaries. */
  buildTxtDict =
    {langInputs ? [], ...}@args:
    buildDict ({
      propagatedUserEnvPackages = langInputs;

      preBuild = ''
        # Aspell can't handle multiple data-dirs
        # Copy everything we might possibly need
        ${concatMapStringsSep "\n" (p: ''
          cp -a ${p}/lib/aspell/* .
        '') ([ aspell ] ++ langInputs)}
        export ASPELL_CONF="data-dir $(pwd)"

        aspell-create() {
          target=$1
          shift
          echo building $target
          aspell create "$@" master ./$target.rws
        }

        words-only() {
          awk -F'\t' '{print $1}' | sort | uniq
        }

        # drop comments
        aspell-affix() {
          words-only \
            | grep -v '#' \
            | aspell-create "$@"
        }

        # Hack: drop comments and words with affixes
        aspell-plain() {
          words-only \
            | grep -v '#' \
            | grep -v '/' \
            | aspell-create "$@"
        }

        aspell-install() {
          install -d $out/lib/aspell
          for a in "$@"; do
            echo installing $a
            install -t $out/lib/aspell $a.rws
          done
        }
      '';

      phases = [ "preBuild" "buildPhase" "installPhase" ];
    } // args);

in rec {

  ### Languages

  ca = buildDict rec {
    shortName = "ca-2.1.5-1";
    fullName = "Catalan";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/ca/aspell6-${shortName}.tar.bz2";
      sha256 = "1fb5y5kgvk25nlsfvc8cai978hg66x3pbp9py56pldc7vxzf9npb";
    };
  };

  cs = buildDict rec {
    shortName = "cs-20040614-1";
    fullName = "Czech";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/cs/aspell6-${shortName}.tar.bz2";
      sha256 = "0rihj4hsw96pd9casvmpvw3r8040pfa28p1h73x4vyn20zwr3h01";
    };
  };

  da = buildDict rec {
    shortName = "da-1.4.42-1";
    fullName = "Danish";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/da/aspell5-${shortName}.tar.bz2";
      sha256 = "1hfkmiyhgrx5lgrb2mffjbdn1hivrm73wcg7x0iid74p2yb0fjpp";
    };
  };

  de = buildDict rec {
    shortName = "de-20030222-1";
    fullName = "German";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/de/aspell6-${shortName}.tar.bz2";
      sha256 = "01p92qj66cqb346gk7hjfynaap5sbcn85xz07kjfdq623ghr8v5s";
    };
  };

  en = buildDict rec {
    shortName = "en-2016.06.26-0";
    fullName = "English";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/en/aspell6-${shortName}.tar.bz2";
      sha256 = "1clzsfq2cbgp6wvfr2qwfsd2nziipml5m5vqm45r748wczlxihv1";
    };
  };

  es = buildDict rec {
    shortName = "es-1.11-2";
    fullName = "Spanish";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/es/aspell6-${shortName}.tar.bz2";
      sha256 = "1k5g328ac1hdpp6fsg57d8md6i0aqcwlszp3gbmp5706wyhpydmd";
    };
  };

  eo = buildDict rec {
    shortName = "eo-2.1.20000225a-2";
    fullName = "Esperanto";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/eo/aspell6-${shortName}.tar.bz2";
      sha256 = "09vf0mbiicbmyb4bwb7v7lgpabnylg0wy7m3hlhl5rjdda6x3lj1";
    };
  };

  fr = buildDict rec {
    shortName = "fr-0.50-3";
    fullName = "French";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/fr/aspell-${shortName}.tar.bz2";
      sha256 = "14ffy9mn5jqqpp437kannc3559bfdrpk7r36ljkzjalxa53i0hpr";
    };
  };

  it = buildDict rec {
    shortName = "it-2.2_20050523-0";
    fullName = "Italian";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/it/aspell6-${shortName}.tar.bz2";
      sha256 = "1gdf7bc1a0kmxsmphdqq8pl01h667mjsj6hihy6kqy14k5qdq69v";
    };
  };

  la = buildDict rec {
    shortName = "la-20020503-0";
    fullName = "Latin";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/la/aspell6-${shortName}.tar.bz2";
      sha256 = "1199inwi16dznzl087v4skn66fl7h555hi2palx6s1f3s54b11nl";
    };
  };

  nb = buildDict rec {
    shortName = "nb-0.50.1-0";
    fullName = "Norwegian Bokmal";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/nb/aspell-${shortName}.tar.bz2";
      sha256 = "12i2bmgdnlkzfinb20j2a0j4a20q91a9j8qpq5vgabbvc65nwx77";
    };
  };

  nl = buildDict rec {
    shortName = "nl-0.50-2";
    fullName = "Dutch";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/nl/aspell-${shortName}.tar.bz2";
      sha256 = "0ffb87yjsh211hllpc4b9khqqrblial4pzi1h9r3v465z1yhn3j4";
    };
    # Emacs expects a language called "nederlands".
    postInstall = ''
      echo "add nl.rws" > $out/lib/aspell/nederlands.multi
    '';
  };

  nn = buildDict rec {
    shortName = "nn-0.50.1-1";
    fullName = "Norwegian Nynorsk";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/nn/aspell-${shortName}.tar.bz2";
      sha256 = "0w2k5l5rbqpliripgqwiqixz5ghnjf7i9ggbrc4ly4vy1ia10rmc";
    };
  };

  pl = buildDict rec {
    shortName = "pl-6.0_20061121-0";
    fullName = "Polish";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/pl/aspell6-${shortName}.tar.bz2";
      sha256 = "0kap4kh6bqbb22ypja1m5z3krc06vv4n0hakiiqmv20anzy42xq1";
    };
  };

  pt_BR = buildDict rec {
    shortName = "pt_BR-20090702-0";
    fullName = "Brazilian Portuguese";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/pt_BR/aspell6-${shortName}.tar.bz2";
      sha256 = "1y09lx9zf2rnp55r16b2vgj953l3538z1vaqgflg9mdvm555bz3p";
    };
  };

  pt_PT = buildDict rec {
    shortName = "pt_PT-20070510-0";
    fullName = "Portuguese";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/pt_PT/aspell6-${shortName}.tar.bz2";
      sha256 = "1mnr994cwlag6shy8865ky99lymysiln07mbldcncahg90dagdxq";
    };
  };

  ro = buildDict rec {
    shortName = "ro-3.3-2";
    fullName = "Romanian";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/ro/aspell5-${shortName}.tar.bz2";
      sha256 = "0gb8j9iy1acdl11jq76idgc2lbc1rq3w04favn8cyh55d1v8phsk";
    };
  };

  ru = buildDict rec {
    shortName = "ru-0.99f7-1";
    fullName = "Russian";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/ru/aspell6-${shortName}.tar.bz2";
      sha256 = "0ip6nq43hcr7vvzbv4lwwmlwgfa60hrhsldh9xy3zg2prv6bcaaw";
    };
  };

  sv = buildDict rec {
    shortName = "sv-0.51-0";
    fullName = "Swedish";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/sv/aspell-${shortName}.tar.bz2";
      sha256 = "02jwkjhr32kvyibnyzgx3smbnm576jwdzg3avdf6zxwckhy5fw4v";
    };
  };

  sk = buildDict rec {
    shortName = "sk-2.01-2";
    fullName = "Slovak";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/sk/aspell6-${shortName}.tar.bz2";
      sha256 = "19k0m1v5pcf7xr4lxgjkzqkdlks8nyb13bvi1n7521f3i4lhma66";
    };
  };

  tr = buildDict rec {
    shortName = "tr-0.50-0";
    fullName = "Turkish";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/tr/aspell-${shortName}.tar.bz2";
      sha256 = "0jpvpm96ga7s7rmsm6rbyrrr22b2dicxv2hy7ysv5y7bbq757ihb";
    };
  };

  uk = buildDict rec {
    shortName = "uk-1.4.0-0";
    fullName = "Ukrainian";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/uk/aspell6-${shortName}.tar.bz2";
      sha256 = "137i4njvnslab6l4s291s11xijr5jsy75lbdph32f9y183lagy9m";
    };
  };

  ### Jargons

  en-computers = buildTxtDict rec {
    shortName = "en-computers";
    fullName = "English Computer Jargon";

    src = fetchurl {
      url = https://mrsatterly.com/computer.dic;
      sha256 = "1vzk7cdvcm9r1c6mgxpabrdcpvghdv9mjmnf6iq5wllcif5nsw2b";
    };

    langInputs = [ en ];

    buildPhase = "cat $src | aspell-affix en-computers --dont-validate-words --lang=en";
    installPhase = "aspell-install en-computers";

    meta = {
      homepage = https://mrsatterly.com/spelling.html;
    };
  };

  en-science = buildTxtDict rec {
    shortName = "en-science";
    fullName = "English Scientific Jargon";

    src1 = fetchurl {
      url = http://jpetrie.net/wp-content/uploads/custom_scientific_US.txt;
      sha256 = "1psqm094zl4prk2f8h18jv0d471hxykzd1zdnrlx7gzrzy6pz5r3";
    };

    src2 = fetchurl {
      url = http://jpetrie.net/wp-content/uploads/custom_scientific_UK.txt;
      sha256 = "17ss1sdr3k70zbyx2z9xf74345slrp41gbkpih8axrmg4x92fgm1";
    };

    langInputs = [ en ];

    buildPhase = ''
      cat $src1 | aspell-plain en_US-science --dont-validate-words --lang=en
      cat $src2 | aspell-plain en_GB-science --dont-validate-words --lang=en
    '';
    installPhase = "aspell-install en_US-science en_GB-science";

    meta = {
      homepage = http://www.jpetrie.net/scientific-word-list-for-spell-checkersspelling-dictionaries/;
    };

  };

}
