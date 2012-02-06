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

  de = buildDict {
    shortName = "de-20030222-1";
    fullName = "German";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/de/aspell6-de-20030222-1.tar.bz2;
      sha256 = "01p92qj66cqb346gk7hjfynaap5sbcn85xz07kjfdq623ghr8v5s";
    };
  };
    
  en = buildDict {
    shortName = "en-6.0-0";
    fullName = "English";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/en/aspell6-en-6.0-0.tar.bz2;
      sha256 = "1628rrx1yq9jmnd86sr24vih101smb818vf10vx97f6j263niw14";
    };
  };
    
  es = buildDict {
    shortName = "es-0.50-2";
    fullName = "Spanish";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/es/aspell-es-0.50-2.tar.bz2;
      sha256 = "0i96xswcng35n5zhgpiswmi5sdpx63kl8bg7fl1zp5j1shr2l3jw";
    };
  };
    
  eo = buildDict {
    shortName = "eo-0.50-2";
    fullName = "Esperanto";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/eo/aspell-eo-0.50-2.tar.bz2;
      sha256 = "19vhdm599ng98nq8jxspgvanv5hwryp0qri1vx6zsjl0jx1acqbc";
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
    shortName = "it-0.53-0";
    fullName = "Italian";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/it/aspell-it-0.53-0.tar.bz2;
      sha256 = "0vzs2mk0h2znx0jjs5lqiwdrc4nf6v3f8xbrsni8pfnxhh5ik1rv";
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
    
  pl = buildDict {
    shortName = "pl-6.0_20061121";
    fullName = "Polish";
    src = fetchurl {
      url = mirror://gnu/aspell/dict/pl/aspell6-pl-6.0_20061121-0.tar.bz2;
      sha256 = "0kap4kh6bqbb22ypja1m5z3krc06vv4n0hakiiqmv20anzy42xq1";
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
    
}
