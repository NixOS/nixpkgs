{ stdenv, lib, fetchurl, pkgconfig, flex, bison, libxslt, autoconf, automake, graphviz
, glib, libiconv, libintl, libtool, expat
}:

let
  generic = { major, minor, sha256, extraNativeBuildInputs ? [], extraBuildInputs ? [] }:
  let
    atLeast = lib.versionAtLeast "${major}.${minor}";
  in stdenv.mkDerivation rec {
    name = "vala-${version}";
    version = "${major}.${minor}";

    src = fetchurl {
      url = "mirror://gnome/sources/vala/${major}/${name}.tar.xz";
      inherit sha256;
    };

    postPatch = ''
      patchShebangs tests
    '';

    outputs = [ "out" "devdoc" ];

    nativeBuildInputs = [
      pkgconfig flex bison libxslt
    ] ++ lib.optional (stdenv.isDarwin && (atLeast "0.38")) expat
      ++ extraNativeBuildInputs;

    buildInputs = [
      glib libiconv libintl
    ] ++ lib.optional (atLeast "0.38") graphviz
      ++ extraBuildInputs;

    doCheck = false; # fails, requires dbus daemon

    meta = with stdenv.lib; {
      description = "Compiler for GObject type system";
      homepage = https://wiki.gnome.org/Projects/Vala;
      license = licenses.lgpl21Plus;
      platforms = platforms.unix;
      maintainers = with maintainers; [ antono jtojnar lethalman peterhoeg ];
    };
  };

in rec {

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
    minor   = "13";
    sha256  = "0gxz7yisd9vh5d2889p60knaifz5zndgj98zkdfkkaykdfdq4m9k";
  };

  vala_0_38 = generic {
    major   = "0.38";
    minor   = "9";
    sha256  = "1dh1qacfsc1nr6hxwhn9lqmhnq39rv8gxbapdmj1v65zs96j3fn3";
    extraNativeBuildInputs = [ autoconf ] ++ lib.optional stdenv.isDarwin libtool;
  };

  vala_0_40 = generic {
    major   = "0.40";
    minor   = "6";
    sha256  = "1qjbwhifwwqbdg5zilvnwm4n76g8p7jwqs3fa0biw3rylzqm193d";
  };

  vala = vala_0_38;
}
