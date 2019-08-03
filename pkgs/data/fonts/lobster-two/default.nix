{stdenv, fetchurl}:

let

  # HG revision in which this version of the font can be fount.
  rev = "8e98053718f9a15184c93d6530885791be71b756";

  urlBase = "https://googlefontdirectory.googlecode.com/hg-history/${rev}/ofl/lobstertwo";

  # Just a small convenience function.
  fetch = {name, path ? "/src", sha256}:
    {
      inherit name;
      file = fetchurl {
        url = "${urlBase}${path}/${name}";
        inherit sha256;
      };
    };

  fontlog =
    fetch {
      name = "FONTLOG.txt";
      path = "";
      sha256 = "0n405i8m70q95y8w43gzr5yvkj7gx7rd3xa4rx6y8qcqv5g7v9if";
    };

  bold =
    fetch {
      name = "LobsterTwo-Bold.otf";
      sha256 = "0gkayn96vvgngs9xnmcyyf16q4payk79ghvl354rl93ayb3gf7x0";
    };

  boldItalic =
    fetch {
      name = "LobsterTwo-BoldItalic.otf";
      sha256 = "0wznqkvwjqi9s4bg10fpp2345by3nxa0m0w6b3al3zaqyx2p1dxp";
    };

  italic =
    fetch {
      name = "LobsterTwo-Italic.otf";
      sha256 = "0lpnzwgwl5fm6gqy8bylbryz0hy94mf1mp615y5sh0wikdvk570z";
    };

  regular =
    fetch {
      name = "LobsterTwo-Regular.otf";
      sha256 = "147m3sa3sqqbkbw1hgjdwnw8w0y37x58g5p09s7q2vm74flcpbq1";
    };
in

  stdenv.mkDerivation rec {
    name = "lobstertwo-${version}";
    version = "1.006";

    phases = ["installPhase"];

    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      mkdir -p $out/share/doc/${name}
      cp -v ${fontlog.file} $out/share/doc/${name}/${fontlog.name}
      cp -v ${bold.file} $out/share/fonts/opentype/${bold.name}
      cp -v ${boldItalic.file} $out/share/fonts/opentype/${boldItalic.name}
      cp -v ${italic.file} $out/share/fonts/opentype/${italic.name}
      cp -v ${regular.file} $out/share/fonts/opentype/${regular.name}
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0if9l8pzwgfnbdjg5yblcy08dwn9yj3wzz29l0fycia46xlzd4ym";

    meta = with stdenv.lib; {
      homepage = https://github.com/librefonts/lobstertwo;
      description = "Script font with many ligatures";
      license = licenses.ofl;
      platforms = platforms.all;
      maintainers = [maintainers.rycee];
      broken = true; # googlecode.com RIP; can be built from sources
    };
  }
