{ stdenv, lib, fetchurl, fetchpatch, pkg-config, flex, bison, libxslt, autoconf, autoreconfHook
, gnome, graphviz, glib, libiconv, libintl, libtool, expat, substituteAll
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

        # NOTE: the openembedded-core project doesn't have a patch for 0.40.12
        # We've fixed the single merge conflict in the following patch.
        #     0.40.12: https://github.com/openembedded/openembedded-core/raw/8553c52f174af4c8c433c543f806f5ed5c1ec48c/meta/recipes-devtools/vala/vala/disable-graphviz.patch
        "0.40" = ./disable-graphviz-0.40.12.patch;

        # NOTE: the openembedded-core project doesn't have a patch for 0.44.1
        # We've reverted the addition of the "--disable-valadoc" option
        # and then applied the following patch.
        #     0.42.4: https://github.com/openembedded/openembedded-core/raw/f2b4f9ec6f44dced7f88df849cca68961419eeb8/meta/recipes-devtools/vala/vala/disable-graphviz.patch
        "0.44" = ./disable-graphviz-0.44.3.patch;

        "0.46" = ./disable-graphviz-0.46.1.patch;

        "0.48" = ./disable-graphviz-0.46.1.patch;

        "0.50" = ./disable-graphviz-0.46.1.patch;

        "0.52" = ./disable-graphviz-0.46.1.patch;

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
    preBuild       = lib.optionalString disableGraphviz "buildFlagsArray+=(\"VALAC=$(pwd)/compiler/valac\")";

    outputs = [ "out" "devdoc" ];

    nativeBuildInputs = [
      pkg-config flex bison libxslt
    ] ++ lib.optional (stdenv.isDarwin && (lib.versionAtLeast version "0.38")) expat
      ++ lib.optional disableGraphviz autoreconfHook # if we changed our ./configure script, need to reconfigure
      ++ extraNativeBuildInputs;

    buildInputs = [
      glib libiconv libintl
    ] ++ lib.optional (lib.versionAtLeast version "0.38" && withGraphviz) graphviz
      ++ extraBuildInputs;

    enableParallelBuilding = true;

    doCheck = false; # fails, requires dbus daemon

    passthru = {
     updateScript = gnome.updateScript {
       attrPath = "${pname}_${lib.versions.major version}_${lib.versions.minor version}";
       packageName = pname;
     };
    };

    meta = with lib; {
      description = "Compiler for GObject type system";
      homepage = "https://wiki.gnome.org/Projects/Vala";
      license = licenses.lgpl21Plus;
      platforms = platforms.unix;
      maintainers = with maintainers; [ antono jtojnar peterhoeg maxeaubrey ] ++ teams.pantheon.members;
    };
  });

in rec {
  vala_0_40 = generic {
    version = "0.40.25";
    sha256 = "1pxpack8rrmywlf47v440hc6rv3vi8q9c6niwqnwikxvb2pwf3w7";
  };

  vala_0_46 = generic {
    version = "0.46.13";
    sha256 = "0d7l4vh2xra3q75kw3sy2d9bn5p6s3g3r7j37bdn6ir8l3wp2ivs";
  };

  vala_0_48 = generic {
    version = "0.48.19";
    sha256 = "sha256-gLdlijfZhE/NG0Mdr8WATeYWpYGW5PHxGeWyrraLSgE=";
  };

  vala_0_50 = generic {
    version = "0.50.10";
    sha256 = "sha256-vnIf8/AYHqttM+zKzygfZvMI+qHl5VTwj99nFZpFlRU=";
  };

  vala_0_52 = generic {
    version = "0.52.5";
    sha256 = "sha256-hKG7MSs+Xcrkt7JcRVmNN14stpIzzvtZoV0jUMdr3ZE=";
  };

  vala = vala_0_52;
}
