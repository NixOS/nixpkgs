{ stdenv, fetchurl, pkgconfig, flex, bison, libxslt, autoconf, graphviz
, glib, libiconv, libintlOrEmpty, libtool, expat
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

    buildInputs = [ glib libiconv ] ++ libintlOrEmpty ++ extraBuildInputs;

    meta = with stdenv.lib; {
      description = "Compiler for GObject type system";
      homepage = http://live.gnome.org/Vala;
      license = licenses.lgpl21Plus;
      platforms = platforms.unix;
      maintainers = with maintainers; [ antono lethalman peterhoeg ];
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
    minor   = "13";
    sha256  = "0ahbnhgwhhjkndmbr1d039ws0g2bb324c60fk6wgx7py5wvmgcd2";
  };

  vala_0_36 = generic {
    major   = "0.36";
    minor   = "8";
    sha256  = "1nz5a8kcb22ss9idb7k1higwpvghd617xwf40fi0a9ggws614lfz";
  };

  vala_0_38 = generic {
    major   = "0.38";
    minor   = "4";
    sha256  = "1sg5gaq3jhgr9vzh2ypiw475167k150wmyglymr7wwqppmikmcrc";
    extraNativeBuildInputs = [ autoconf ] ++ stdenv.lib.optionals stdenv.isDarwin [ libtool expat ];
    extraBuildInputs = [ graphviz ];
  };

  vala = vala_0_38;
}
