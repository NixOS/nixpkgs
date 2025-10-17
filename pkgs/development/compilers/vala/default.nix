{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  flex,
  bison,
  libxslt,
  autoconf,
  autoreconfHook,
  gnome,
  graphviz,
  glib,
  libiconv,
  libintl,
  libtool,
  expat,
  replaceVars,
  vala,
  gobject-introspection,
}:

let
  generic = lib.makeOverridable (
    {
      version,
      hash,
      extraNativeBuildInputs ? [ ],
      extraBuildInputs ? [ ],
      withGraphviz ? false,
    }:
    let
      # Build vala (valadoc) without graphviz support. Inspired from the openembedded-core project.
      # https://github.com/openembedded/openembedded-core/blob/a5440d4288e09d3e/meta/recipes-devtools/vala/vala/disable-graphviz.patch
      graphvizPatch =
        {
          "0.56" = ./disable-graphviz-0.56.8.patch;
        }
        .${lib.versions.majorMinor version} or (throw "no graphviz patch for this version of vala");

      disableGraphviz = !withGraphviz;

    in
    stdenv.mkDerivation rec {
      pname = "vala";
      inherit version;

      setupHook = replaceVars ./setup-hook.sh {
        apiVersion = lib.versions.majorMinor version;
      };

      src = fetchurl {
        url = "mirror://gnome/sources/vala/${lib.versions.majorMinor version}/vala-${version}.tar.xz";
        inherit hash;
      };

      postPatch = ''
        patchShebangs tests
      '';

      # If we're disabling graphviz, apply the patches and corresponding
      # configure flag. We also need to override the path to the valac compiler
      # so that it can be used to regenerate documentation.
      patches = lib.optionals disableGraphviz [ graphvizPatch ];
      configureFlags = lib.optional disableGraphviz "--disable-graphviz";
      # when cross-compiling ./compiler/valac is valac for host
      # so add the build vala in nativeBuildInputs
      preBuild = lib.optionalString (
        disableGraphviz && (stdenv.buildPlatform == stdenv.hostPlatform)
      ) "buildFlagsArray+=(\"VALAC=$(pwd)/compiler/valac\")";

      outputs = [
        "out"
        "devdoc"
      ];

      nativeBuildInputs = [
        pkg-config
        flex
        bison
        libxslt
        gobject-introspection
      ]
      ++ lib.optional (stdenv.hostPlatform.isDarwin) expat
      ++ lib.optional disableGraphviz autoreconfHook # if we changed our ./configure script, need to reconfigure
      ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ vala ]
      ++ extraNativeBuildInputs;

      buildInputs = [
        glib
        libiconv
        libintl
      ]
      ++ lib.optional withGraphviz graphviz
      ++ extraBuildInputs;

      enableParallelBuilding = true;

      doCheck = false; # fails, requires dbus daemon

      passthru = {
        updateScript = gnome.updateScript {
          attrPath =
            let
              roundUpToEven = num: num + lib.mod num 2;
            in
            "vala_${lib.versions.major version}_${toString (roundUpToEven (lib.toInt (lib.versions.minor version)))}";
          packageName = "vala";
          freeze = true;
        };
      };

      meta = with lib; {
        description = "Compiler for GObject type system";
        homepage = "https://vala.dev";
        license = licenses.lgpl21Plus;
        platforms = platforms.unix;
        maintainers = with maintainers; [
          antono
          jtojnar
        ];
        teams = [ teams.pantheon ];
      };
    }
  );

in
rec {
  vala_0_56 = generic {
    version = "0.56.18";
    hash = "sha256-8q/+fUCrY9uOe57MP2vcnC/H4xNMhP8teV9IL+kmo4I=";
  };

  vala = vala_0_56;
}
