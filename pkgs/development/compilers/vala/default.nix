{ stdenv, fetchurl, pkgconfig, flex, bison, libxslt, autoconf, graphviz
, glib, libiconv, libintl, libtool, expat
}:

let
  generic = { major, minor, sha256, extraNativeBuildInputs ? [], extraBuildInputs ? [] }:
  stdenv.mkDerivation rec {
    name = "vala-${major}.${minor}";

    src = fetchurl {
      url = "mirror://gnome/sources/vala/${major}/${name}.tar.xz";
      inherit sha256;
    };

    outputs = [ "out" "devdoc" ];

    nativeBuildInputs = [ pkgconfig flex bison libxslt ] ++ extraNativeBuildInputs;

    buildInputs = [ glib libiconv libintl ] ++ extraBuildInputs;

    meta = with stdenv.lib; {
      description = "Compiler for GObject type system";
      homepage = https://wiki.gnome.org/Projects/Vala;
      license = licenses.lgpl21Plus;
      platforms = platforms.unix;
      maintainers = with maintainers; [ antono jtojnar lethalman peterhoeg ];
    };
  };

in rec {

  vala_0_23 = generic {
    major   = "0.23";
    minor   = "3";
    sha256  = "101xjbc818g4849n9a80c2aai13zakj7mpnd7470xnkvz5jwqq96";
  };

  vala_0_26 = generic {
    major   = "0.26";
    minor   = "2";
    sha256  = "1i03ds1z5hivqh4nhf3x80fg7n0zd22908w5minkpaan1i1kzw9p";
  };

  vala_0_28 = generic {
    major   = "0.28";
    minor   = "1";
    sha256  = "0isg327w6rfqqdjja6a8pc3xcdkj7pqrkdhw48bsyxab2fkaw3hw";
  };

  vala_0_32 = generic {
    major   = "0.32";
    minor   = "1";
    sha256  = "1ab1l44abf9fj1wznzq5956431ia136rl5049cggnk5393jlf3fx";
  };

  vala_0_34 = generic {
    major   = "0.34";
    minor   = "17";
    sha256  = "0wd2zxww4z1ys4iqz218lvzjqjjqwsaad4x2by8pcyy43sbr7qp2";
  };

  vala_0_36 = generic {
    major   = "0.36";
    minor   = "12";
    sha256  = "1nvw721piwdh15bipg0sdll9kvgpz0y9i5fpszlc7y9w64yis25l";
  };

  vala_0_38 = generic {
    major   = "0.38";
    minor   = "4";
    sha256  = "1sg5gaq3jhgr9vzh2ypiw475167k150wmyglymr7wwqppmikmcrc";
    extraNativeBuildInputs = [ autoconf ] ++ stdenv.lib.optionals stdenv.isDarwin [ libtool expat ];
    extraBuildInputs = [ graphviz ];
  };

  vala_0_40 = generic {
    major   = "0.40";
    minor   = "0";
    sha256  = "0wcfljl55a9qvslfcc4sf76wdpwgn83n96b7fgb7r49ib35qz20m";
    extraNativeBuildInputs = stdenv.lib.optionals stdenv.isDarwin [ expat ];
    extraBuildInputs = [ graphviz ];
  };

  vala = vala_0_38;
}
