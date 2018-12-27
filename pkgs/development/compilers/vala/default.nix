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
  vala_0_36 = generic {
    major   = "0.36";
    minor   = "17";
    sha256  = "1f6qg40zd6jzhbwr3dy4fb66k4qs1xlk2whdyqh64zxxjw0k9pv7";
  };

  vala_0_38 = generic {
    major   = "0.38";
    minor   = "10";
    sha256  = "1rdwwqs973qv225v8b5izcgwvqn56jxgr4pa3wxxbliar3aww5sw";
    extraNativeBuildInputs = [ autoconf ] ++ lib.optional stdenv.isDarwin libtool;
  };

  vala_0_40 = generic {
    major   = "0.40";
    minor   = "12";
    sha256  = "1nhk45w5iwg97q3cfybn0i4qz5w9qvk423ndpg6mq6cnna076snx";
  };

  vala_0_42 = generic {
    major   = "0.42";
    minor   = "4";
    sha256  = "07jgkx812y7wq4cswwfsf1f4k3lq9hcjra45682bdi8a11nr0a5m";
  };

  vala = vala_0_42;
}
