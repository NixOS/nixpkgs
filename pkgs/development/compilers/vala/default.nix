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

    enableParallelBuilding = true;

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
  vala_0_34 = generic {
    major   = "0.34";
    minor   = "18";
    sha256  = "1lhw3ghns059y5d6pdldy5p4yjwlhcls84k892i6qmbhxg34945q";
  };

  vala_0_36 = generic {
    major   = "0.36";
    minor   = "15";
    sha256  = "11lnwjbhiz2l7g6y1f0jb0s81ymgssinlil3alibzcwmzpk175ix";
  };

  vala_0_38 = generic {
    major   = "0.38";
    minor   = "10";
    sha256  = "1rdwwqs973qv225v8b5izcgwvqn56jxgr4pa3wxxbliar3aww5sw";
    extraNativeBuildInputs = [ autoconf ] ++ lib.optional stdenv.isDarwin libtool;
  };

  vala_0_40 = generic {
    major   = "0.40";
    minor   = "11";
    sha256  = "0xhm61kjdws167pafcji43s7icfvpq58lkbq3irb1jv3icjr3i8z";
  };

  vala_0_42 = generic {
    major   = "0.42";
    minor   = "3";
    sha256  = "0zaq9009wqk5aah131m426a2ia0scwpjpl4npf8p7p43wv8kvisz";
  };

  vala = vala_0_42;
}
