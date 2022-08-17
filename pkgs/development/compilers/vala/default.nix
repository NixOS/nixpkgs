{ stdenv, lib, fetchurl, fetchpatch, pkg-config, flex, bison, libxslt, autoconf, autoreconfHook
, gnome, graphviz, glib, libiconv, libintl, libtool, expat, substituteAll, vala
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
      {
        "0.48" = ./disable-graphviz-0.46.1.patch;

        "0.54" = ./disable-graphviz-0.46.1.patch;

        "0.56" = ./disable-graphviz-0.46.1.patch;

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
    # when cross-compiling ./compiler/valac is valac for host
    # so add the build vala in nativeBuildInputs
    preBuild       = lib.optionalString (disableGraphviz && (stdenv.buildPlatform == stdenv.hostPlatform)) "buildFlagsArray+=(\"VALAC=$(pwd)/compiler/valac\")";

    outputs = [ "out" "devdoc" ];

    nativeBuildInputs = [
      pkg-config flex bison libxslt
    ] ++ lib.optional (stdenv.isDarwin && (lib.versionAtLeast version "0.38")) expat
      ++ lib.optional disableGraphviz autoreconfHook # if we changed our ./configure script, need to reconfigure
      ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ vala ]
      ++ extraNativeBuildInputs;

    buildInputs = [
      glib libiconv libintl
    ] ++ lib.optional (lib.versionAtLeast version "0.38" && withGraphviz) graphviz
      ++ extraBuildInputs;

    enableParallelBuilding = true;

    doCheck = false; # fails, requires dbus daemon

    passthru = {
      updateScript = gnome.updateScript {
        attrPath =
          let
            roundUpToEven = num: num + lib.mod num 2;
          in "${pname}_${lib.versions.major version}_${builtins.toString (roundUpToEven (lib.toInt (lib.versions.minor version)))}";
        packageName = pname;
        freeze = true;
      };
    };

    meta = with lib; {
      description = "Compiler for GObject type system";
      homepage = "https://wiki.gnome.org/Projects/Vala";
      license = licenses.lgpl21Plus;
      platforms = platforms.unix;
      maintainers = with maintainers; [ antono jtojnar maxeaubrey ] ++ teams.pantheon.members;
    };
  });

in rec {
  vala_0_48 = generic {
    version = "0.48.24";
    sha256 = "NknvhFc7aGX8NHBkDuYDcgCZ65FbOfqtGbdJjeGn3yQ=";
  };

  vala_0_54 = generic {
    version = "0.54.8";
    sha256 = "7fs+eUhqS/SM666pKR5X/HfakyK2lh6VSd9tlz0EvIA=";
  };

  vala_0_56 = generic {
    version = "0.56.2";
    sha256 = "Zslhm7F4Wf0aw6ugpXlwYT44/Soe4wVBF0JgyfuQEkw=";
  };

  vala = vala_0_56;
}
