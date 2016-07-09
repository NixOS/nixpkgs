{stdenv, fetchurl, aspell, which}:

let

  /* Function to compile an Aspell dictionary.  Fortunately, they all
     build in the exact same way. */
  buildDict =
    {shortName, fullName, src, postInstall ? ""}:

    stdenv.mkDerivation {
      name = "aspell-dict-${shortName}";

      inherit src;

      buildInputs = [aspell which];

      dontAddPrefix = true;

      preBuild = "makeFlagsArray=(dictdir=$out/lib/aspell datadir=$out/lib/aspell)";

      inherit postInstall;

      meta = {
        description = "Aspell dictionary for ${fullName}";
        platforms = stdenv.lib.platforms.all;
      };
    };

in {

  cs = buildDict {
    shortName = "cs-20040614-1";
    fullName = "Czech";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/cs/aspell6-cs-20040614-1.tar.bz2;
      sha256 = "0rihj4hsw96pd9casvmpvw3r8040pfa28p1h73x4vyn20zwr3h01";
    };
  };

  da = buildDict {
    shortName = "da-1.4.42-1";
    fullName = "Danish";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/da/aspell5-da-1.4.42-1.tar.bz2;
      sha256 = "1hfkmiyhgrx5lgrb2mffjbdn1hivrm73wcg7x0iid74p2yb0fjpp";
    };
  };

  de = buildDict {
    shortName = "de-20030222-1";
    fullName = "German";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/de/aspell6-de-20030222-1.tar.bz2;
      sha256 = "01p92qj66cqb346gk7hjfynaap5sbcn85xz07kjfdq623ghr8v5s";
    };
  };

  en = buildDict {
    shortName = "en-2016.06.26-0";
    fullName = "English";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/en/aspell6-en-2016.06.26-0.tar.bz2;
      sha256 = "1clzsfq2cbgp6wvfr2qwfsd2nziipml5m5vqm45r748wczlxihv1";
    };
  };

  es = buildDict {
    shortName = "es-1.11-2";
    fullName = "Spanish";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/es/aspell6-es-1.11-2.tar.bz2;
      sha256 = "1k5g328ac1hdpp6fsg57d8md6i0aqcwlszp3gbmp5706wyhpydmd";
    };
  };

  eo = buildDict {
    shortName = "eo-2.1.20000225a-2";
    fullName = "Esperanto";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/eo/aspell6-eo-2.1.20000225a-2.tar.bz2;
      sha256 = "09vf0mbiicbmyb4bwb7v7lgpabnylg0wy7m3hlhl5rjdda6x3lj1";
    };
  };

  fr = buildDict {
    shortName = "fr-0.50-3";
    fullName = "French";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/fr/aspell-fr-0.50-3.tar.bz2;
      sha256 = "14ffy9mn5jqqpp437kannc3559bfdrpk7r36ljkzjalxa53i0hpr";
    };
  };

  it = buildDict {
    shortName = "it-2.2_20050523-0";
    fullName = "Italian";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/it/aspell6-it-2.2_20050523-0.tar.bz2;
      sha256 = "1gdf7bc1a0kmxsmphdqq8pl01h667mjsj6hihy6kqy14k5qdq69v";
    };
  };

  la = buildDict {
    shortName = "la-20020503-0";
    fullName = "Latin";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/la/aspell6-la-20020503-0.tar.bz2;
      sha256 = "1199inwi16dznzl087v4skn66fl7h555hi2palx6s1f3s54b11nl";
    };
  };

  nb = buildDict {
    shortName = "nb-0.50.1-0";
    fullName = "Norwegian Bokmal";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/nb/aspell-nb-0.50.1-0.tar.bz2";
      sha256 = "12i2bmgdnlkzfinb20j2a0j4a20q91a9j8qpq5vgabbvc65nwx77";
    };
  };

  nl = buildDict {
    shortName = "nl-0.50-2";
    fullName = "Dutch";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/nl/aspell-nl-0.50-2.tar.bz2;
      sha256 = "0ffb87yjsh211hllpc4b9khqqrblial4pzi1h9r3v465z1yhn3j4";
    };
    # Emacs expects a language called "nederlands".
    postInstall = ''
      echo "add nl.rws" > $out/lib/aspell/nederlands.multi
    '';
  };

  nn = buildDict {
    shortName = "nn-0.50.1-0";
    fullName = "Norwegian Nynorsk";
    src = fetchurl {
      url = "mirror://gnu/aspell/dict/nn/aspell-nn-0.50.1-1.tar.bz2";
      sha256 = "0w2k5l5rbqpliripgqwiqixz5ghnjf7i9ggbrc4ly4vy1ia10rmc";
    };
  };

  pl = buildDict {
    shortName = "pl-6.0_20061121-0";
    fullName = "Polish";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/pl/aspell6-pl-6.0_20061121-0.tar.bz2;
      sha256 = "0kap4kh6bqbb22ypja1m5z3krc06vv4n0hakiiqmv20anzy42xq1";
    };
  };

  pt_BR = buildDict {
    shortName = "pt_BR-20090702";
    fullName = "Brazilian Portuguese";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/pt_BR/aspell6-pt_BR-20090702-0.tar.bz2;
      sha256 = "1y09lx9zf2rnp55r16b2vgj953l3538z1vaqgflg9mdvm555bz3p";
    };
  };

  pt_PT = buildDict {
    shortName = "pt_PT-20070510";
    fullName = "Portuguese";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/pt_PT/aspell6-pt_PT-20070510-0.tar.bz2;
      sha256 = "1mnr994cwlag6shy8865ky99lymysiln07mbldcncahg90dagdxq";
    };
  };

  ro = buildDict {
    shortName = "ro-3.3-2";
    fullName = "Romanian";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/ro/aspell5-ro-3.3-2.tar.bz2;
      sha256 = "0gb8j9iy1acdl11jq76idgc2lbc1rq3w04favn8cyh55d1v8phsk";
    };
  };

  ru = buildDict {
    shortName = "ru-0.99f7-1";
    fullName = "Russian";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/ru/aspell6-ru-0.99f7-1.tar.bz2;
      sha256 = "0ip6nq43hcr7vvzbv4lwwmlwgfa60hrhsldh9xy3zg2prv6bcaaw";
    };
  };

  sv = buildDict {
    shortName = "sv-0.51-0";
    fullName = "Swedish";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/sv/aspell-sv-0.51-0.tar.bz2;
      sha256 = "02jwkjhr32kvyibnyzgx3smbnm576jwdzg3avdf6zxwckhy5fw4v";
    };
  };

  sk = buildDict {
    shortName = "sk-2.01-2";
    fullName = "Slovak";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/sk/aspell6-sk-2.01-2.tar.bz2;
      sha256 = "19k0m1v5pcf7xr4lxgjkzqkdlks8nyb13bvi1n7521f3i4lhma66";
    };
  };

  uk = buildDict {
    shortName = "uk-1.4.0-0";
    fullName = "Ukrainian";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/uk/aspell6-uk-1.4.0-0.tar.bz2;
      sha256 = "137i4njvnslab6l4s291s11xijr5jsy75lbdph32f9y183lagy9m";
    };
  };

}
