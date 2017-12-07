{ stdenv, fetchurl, pkgconfig, flex, bison, libxslt
, glib, libiconv, libintlOrEmpty
}:

let
  generic = { major, minor, sha256 }:
  stdenv.mkDerivation rec {
    name = "vala-${major}.${minor}";

    src = fetchurl {
      url = "mirror://gnome/sources/vala/${major}/${name}.tar.xz";
      inherit sha256;
    };

    nativeBuildInputs = [ pkgconfig flex bison libxslt ];

    buildInputs = [ glib libiconv ] ++ libintlOrEmpty;

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
    minor   = "2";
    sha256  = "0g22ss9qbm3fqhx4fxhsyfmdc5g1hgdw4dz9d37f4489kl0qf8pl";
  };

  vala_0_26 = generic {
    major   = "0.26";
    minor   = "2";
    sha256  = "1i03ds1z5hivqh4nhf3x80fg7n0zd22908w5minkpaan1i1kzw9p";
  };

  vala_0_28 = generic {
    major   = "0.28";
    minor   = "0";
    sha256  = "0zwpzhkhfk3piya14m7p2hl2vaabahprphppfm46ci91z39kp7hd";
  };

  vala_0_32 = generic {
    major   = "0.32";
    minor   = "1";
    sha256  = "1ab1l44abf9fj1wznzq5956431ia136rl5049cggnk5393jlf3fx";
  };

  vala_0_34 = generic {
    major   = "0.34";
    minor   = "1";
    sha256  = "16cjybjw100qps6jg0jdyjh8hndz8a876zmxpybnf30a8vygrk7m";
  };

  vala = vala_0_34;
}
