{ stdenv, lib, fetchurl, fetchpatch, pkgconfig, flex, bison, libxslt, autoconf, automake, autoreconfHook
, graphviz, glib, libiconv, libintl, libtool, expat, substituteAll
}:

let
  generic = lib.makeOverridable ({
    version, sha256,
    extraNativeBuildInputs ? [],
    extraBuildInputs ? [],
    withGraphviz ? false
  }:
  let
    # Patches from the openembedded-core project to build vala without graphviz
    # support. We need to apply an additional patch to allow building when the
    # header file isn't available at all, but that patch (./gvc-compat.patch)
    # can be shared between all versions of Vala so far.
    graphvizPatch =
      let
        fp = { commit, sha256 }: fetchpatch {
          url = "https://github.com/openembedded/openembedded-core/raw/${commit}/meta/recipes-devtools/vala/vala/disable-graphviz.patch";
          inherit sha256;
        };

      in {
        "0.38" = fp {
          commit = "2c290f7253bba5ceb0d32e7d0b0ec0d0e81cc263";
          sha256 = "056ybapfx18d7xw1k8k85nsjrc26qk2q2d9v9nz2zrcwbq5brhkp";
        };

        # NOTE: the openembedded-core project doesn't have a patch for 0.40.12
        # We've fixed the single merge conflict in the following patch.
        #     0.40.12: https://github.com/openembedded/openembedded-core/raw/8553c52f174af4c8c433c543f806f5ed5c1ec48c/meta/recipes-devtools/vala/vala/disable-graphviz.patch
        "0.40" = ./disable-graphviz-0.40.12.patch;

        "0.42" = fp {
          commit = "f2b4f9ec6f44dced7f88df849cca68961419eeb8";
          sha256 = "112qhdzix0d7lfpfcam1cxprzmfzpwypb1226m5ma1vq9qy0sn7g";
        };

        # NOTE: the openembedded-core project doesn't have a patch for 0.44.1
        # We've reverted the addition of the "--disable-valadoc" option
        # and then applied the following patch.
        #     0.42.4: https://github.com/openembedded/openembedded-core/raw/f2b4f9ec6f44dced7f88df849cca68961419eeb8/meta/recipes-devtools/vala/vala/disable-graphviz.patch
        "0.44" = ./disable-graphviz-0.44.3.patch;

      }.${lib.versions.majorMinor version} or (throw "no graphviz patch for this version of vala");

    disableGraphviz = lib.versionAtLeast version "0.38" && !withGraphviz;

  in stdenv.mkDerivation rec {
    pname = "vala";
    inherit version;

    setupHook = substituteAll {
      src = ./setup-hook.sh;
      apiVersion = lib.versions.majorMinor version;
    };

    src = fetchurl {
      url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
      inherit sha256;
    };

    postPatch = ''
      patchShebangs tests
    '';

    # If we're disabling graphviz, apply the patches and corresponding
    # configure flag. We also need to override the path to the valac compiler
    # so that it can be used to regenerate documentation.
    patches        = lib.optionals disableGraphviz [ graphvizPatch ./gvc-compat.patch ];
    configureFlags = lib.optional  disableGraphviz "--disable-graphviz";
    preBuild       = lib.optional  disableGraphviz "buildFlagsArray+=(\"VALAC=$(pwd)/compiler/valac\")";

    outputs = [ "out" "devdoc" ];

    nativeBuildInputs = [
      pkgconfig flex bison libxslt
    ] ++ lib.optional (stdenv.isDarwin && (lib.versionAtLeast version "0.38")) expat
      ++ lib.optional disableGraphviz autoreconfHook # if we changed our ./configure script, need to reconfigure
      ++ extraNativeBuildInputs;

    buildInputs = [
      glib libiconv libintl
    ] ++ lib.optional (lib.versionAtLeast version "0.38" && withGraphviz) graphviz
      ++ extraBuildInputs;

    enableParallelBuilding = true;

    doCheck = false; # fails, requires dbus daemon

    # Wait for PR #59372
    #passthru = {
    #  updateScript = gnome3.updateScript {
    #    attrPath = "${pname}_${lib.versions.major version}_${lib.versions.minor version}";
    #    packageName = pname;
    #  };
    #};

    meta = with stdenv.lib; {
      description = "Compiler for GObject type system";
      homepage = https://wiki.gnome.org/Projects/Vala;
      license = licenses.lgpl21Plus;
      platforms = platforms.unix;
      maintainers = with maintainers; [ antono jtojnar lethalman peterhoeg worldofpeace ];
    };
  });

in rec {
  vala_0_36 = generic {
    version = "0.36.19";
    sha256 = "05si2f4zjvq0q3wqfh1wxdq20jy1xqxq2skqh8vfh2jyp355lwar";
  };

  vala_0_38 = generic {
    version = "0.38.10";
    sha256  = "1rdwwqs973qv225v8b5izcgwvqn56jxgr4pa3wxxbliar3aww5sw";
    extraNativeBuildInputs = [ autoconf ] ++ lib.optional stdenv.isDarwin libtool;
  };

  vala_0_40 = generic {
    version = "0.40.15";
    sha256 = "0mfayli159yyw6abjf6sgq41j54mr3nspg25b1kxhypcz0scjm19";
  };

  vala_0_42 = generic {
    version = "0.42.7";
    sha256 = "029ksbsdpl581wzy570kj4kkw8b4bizgh494c051zsvkwck55p83";
  };

  vala_0_44 = generic {
    version = "0.44.3";
    sha256 = "1sgas7z6y9r2mf4pxry3fx2awdnzn3vlg2sxd3hqpy2a90ib8lw5";
  };

  vala = vala_0_44;
}
