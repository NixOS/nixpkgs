{ pkgs, config, idris-no-deps, overrides ? (self: super: {}) }: let
  inherit (pkgs.lib) callPackageWith fix' extends;

  /* Taken from haskell-modules/default.nix, should probably abstract this away */
  callPackageWithScope = scope: drv: args: (callPackageWith scope drv args) // {
    overrideScope = f: callPackageWithScope (mkScope (fix' (extends f scope.__unfix__))) drv args;
  };

  mkScope = scope : pkgs // pkgs.xorg // pkgs.gnome2 // scope;

  idrisPackages = self: let
    defaultScope = mkScope self;

    callPackage = callPackageWithScope defaultScope;

    builtins_ = pkgs.lib.mapAttrs self.build-builtin-package {
      prelude = [];

      base = [ self.prelude ];

      contrib = [ self.prelude self.base ];

      effects = [ self.prelude self.base ];

      pruviloj = [ self.prelude self.base ];
    };

  in
    {
    inherit idris-no-deps callPackage;

    # Idris wrapper with specified compiler and library paths, used to build packages

    idris = pkgs.callPackage ./idris-wrapper.nix {
      inherit idris-no-deps;
    };

    # Utilities for building packages

    with-packages = callPackage ./with-packages.nix {} ;

    build-builtin-package = callPackage ./build-builtin-package.nix {};

    build-idris-package = callPackage ./build-idris-package.nix {};

    # The set of libraries that comes with idris

    builtins = pkgs.lib.mapAttrsToList (name: value: value) builtins_;

    # Libraries

    array = callPackage ./array.nix {};

    bi = callPackage ./bi.nix {};

    bifunctors = callPackage ./bifunctors.nix {};

    bytes = callPackage ./bytes.nix {};

    canvas = callPackage ./canvas.nix {};

    categories = callPackage ./categories.nix {};

    coda = callPackage ./coda.nix {};

    config = callPackage ./config.nix {};

    comonad = callPackage ./comonad.nix {};

    composition = callPackage ./composition.nix {};

    console = callPackage ./console.nix {};

    containers = callPackage ./containers.nix {};

    cube = callPackage ./cube.nix {};

    derive = callPackage ./derive.nix {};

    descncrunch = callPackage ./descncrunch.nix {};

    dict = callPackage ./dict.nix {};

    dom = callPackage ./dom.nix {};

    electron = callPackage ./electron.nix {};

    eternal = callPackage ./eternal.nix {};

    farrp = callPackage ./farrp.nix {};

    free = callPackage ./free.nix {};

    fsm = callPackage ./fsm.nix {};

    glfw = callPackage ./glfw.nix {};

    graphviz = callPackage ./graphviz.nix {};

    hamt = callPackage ./hamt.nix {};

    html = callPackage ./html.nix {};

    hezarfen = callPackage ./hezarfen.nix {};

    hrtime = callPackage ./hrtime.nix {};

    http = callPackage ./http.nix {};

    http4idris = callPackage ./http4idris.nix {};

    iaia = callPackage ./iaia.nix {};

    idrishighlighter = callPackage ./idrishighlighter.nix {};

    idrisscript = callPackage ./idrisscript.nix {};

    ipkgparser = callPackage ./ipkgparser.nix {};

    jheiling-extras = callPackage ./jheiling-extras.nix {};

    jheiling-js = callPackage ./jheiling-js.nix {};

    js = callPackage ./js.nix {};

    lens = callPackage ./lens.nix {};

    lightyear = callPackage ./lightyear.nix {};

    logic = callPackage ./logic.nix {};

    mapping = callPackage ./mapping.nix {};

    mhd = callPackage ./mhd.nix {};

    pacman = callPackage ./pacman.nix {};

    patricia = callPackage ./patricia.nix {};

    permutations = callPackage ./permutations.nix {};

    pfds = callPackage ./pfds.nix {};

    pipes = callPackage ./pipes.nix {};

    posix = callPackage ./posix.nix {};

    quantities = callPackage ./quantities.nix {};

    rationals = callPackage ./rationals.nix {};

    recursion_schemes = callPackage ./recursion_schemes.nix {};

    refined = callPackage ./refined.nix {};

    sdl2 = callPackage ./sdl2.nix {};

    semidirect = callPackage ./semidirect.nix {};

    setoids = callPackage ./setoids.nix {};

    smproc = callPackage ./smproc.nix {};

    snippets = callPackage ./snippets.nix {};

    software_foundations = callPackage ./software_foundations.nix {};

    specdris = callPackage ./specdris.nix {};

    tap = callPackage ./tap.nix {};

    test = callPackage ./test.nix {};

    tf-random = callPackage ./tfrandom.nix {};

    tlhydra = callPackage ./tlhydra.nix {};

    tomladris = callPackage ./tomladris.nix {};

    tp = callPackage ./tp.nix {};

    tparsec = callPackage ./tparsec.nix {};

    transducers = callPackage ./transducers.nix {};

    trees = callPackage ./trees.nix {};

    union_type = callPackage ./union_type.nix {};

    vdom = callPackage ./vdom.nix {};

    vecspace = callPackage ./vecspace.nix {};

    webgl = callPackage ./webgl.nix {};

    wl-pprint = callPackage ./wl-pprint.nix {};

    wyvern = callPackage ./wyvern.nix {};

    xhr = callPackage ./xhr.nix {};

    yaml = callPackage ./yaml.nix {};

    yampa = callPackage ./yampa.nix {};

  } // builtins_ // pkgs.lib.optionalAttrs config.allowAliases {
    # removed packages
    protobuf = throw "idrisPackages.protobuf has been removed: abandoned by upstream"; # Added 2022-02-06
    sdl = throw "'idrisPackages.sdl' has been removed, as it was broken and unmaintained"; # added 2024-05-09
  };
in fix' (extends overrides idrisPackages)
