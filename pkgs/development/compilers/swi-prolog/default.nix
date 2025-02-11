{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,

  libxcrypt,
  zlib,
  openssl,
  gmp,
  gperftools,
  readline,
  libedit,
  libarchive,
  Security,

  # optional dependencies
  withDb ? true,
  db,

  withJava ? true,
  jdk,

  withOdbc ? true,
  unixODBC,

  withPcre ? true,
  pcre2,

  withPython ? true,
  python3,

  withYaml ? true,
  libyaml,

  withGui ? false,
  libX11,
  libXpm,
  libXext,
  libXft,
  libXinerama,
  libjpeg,
  libXt,
  libSM,
  freetype,
  fontconfig,

  # gcc/g++ as runtime dependency
  withNativeCompiler ? true,

  # Packs must be installed from a local directory during the build, with dependencies
  # resolved manually, e.g. to install the 'julian' pack, which depends on the 'delay', 'list_util' and 'typedef' packs:
  #   julian = pkgs.fetchzip {
  #     name = "swipl-pack-julian";
  #     url = "https://github.com/mndrix/julian/archive/v0.1.3.zip";
  #     sha256 = "1sgql7c21p3c5m14kwa0bcmlwn9fql612krn9h36gla1j9yjdfgy";
  #   };
  #   delay = pkgs.fetchzip {
  #     name = "swipl-pack-delay";
  #     url = "https://github.com/mndrix/delay/archive/v0.3.3.zip";
  #     sha256 = "0ira87afxnc2dnbbmgwmrr8qvary8lhzvhqwd52dccm6yqd3nybg";
  #   };
  #   list_util = pkgs.fetchzip {
  #     name = "swipl-pack-list_util";
  #     url = "https://github.com/mndrix/list_util/archive/v0.13.0.zip";
  #     sha256 = "0lx7vffflak0y8l8vg8k0g8qddwwn23ksbz02hi3f8rbarh1n89q";
  #   };
  #   typedef = builtins.fetchTarball {
  #     name = "swipl-pack-typedef";
  #     url = "https://raw.githubusercontent.com/samer--/prolog/master/typedef/release/typedef-0.1.9.tgz";
  #     sha256 = "056nqjn01g18fb1b2qivv9s7hb4azk24nx2d4kvkbmm1k91f44p3";
  #   };
  #   swi-prolog = pkgs.swi-prolog.override { extraPacks = map (dep-path: "'file://${dep-path}'") [
  #     julian delay list_util typedef
  #   ]; };
  extraPacks ? [ ],
  extraLibraries ? [ ], # removed option - see below
}:

let
  # minorVersion is even for stable, odd for unstable
  version = "9.2.7";

  # This package provides several with* options, which replaces the old extraLibraries option.
  # This error should help users that still use this option find their way to these flags.
  # We can probably remove this after one NixOS version.
  extraLibraries' =
    if extraLibraries == [ ] then
      [ ]
    else
      throw "option 'extraLibraries' removed - use 'with*' options (e.g., 'withJava'), or overrideAttrs to inject extra build dependencies";

  packInstall = swiplPath: pack: ''
    ${swiplPath}/bin/swipl -g "pack_install(${pack}, [package_directory(\"${swiplPath}/lib/swipl/extra-pack\"), silent(true), interactive(false), git(false)])." -t "halt."
  '';
  withGui' = withGui && !stdenv.hostPlatform.isDarwin;
  optionalDependencies =
    [ ]
    ++ (lib.optional withDb db)
    ++ (lib.optional withJava jdk)
    ++ (lib.optional withOdbc unixODBC)
    ++ (lib.optional withPcre pcre2)
    ++ (lib.optional withPython python3)
    ++ (lib.optional withYaml libyaml)
    ++ (lib.optionals withGui' [
      libXt
      libXext
      libXpm
      libXft
      libXinerama
      libjpeg
      libSM
      freetype
      fontconfig
    ])
    ++ (lib.optional stdenv.hostPlatform.isDarwin Security)
    ++ extraLibraries';
in
stdenv.mkDerivation {
  pname = "swi-prolog";
  inherit version;

  # SWI-Prolog has two repositories: swipl and swipl-devel.
  # - `swipl`, which tracks stable releases and backports
  # - `swipl-devel` which tracks continuous development
  src = fetchFromGitHub {
    owner = "SWI-Prolog";
    repo = "swipl";
    rev = "V${version}";
    hash = "sha256-O9ogltcbBST111FA85jEVW6jGOLJSt/5PeBABtMu2Ws=";
    fetchSubmodules = true;
  };

  # Add the packInstall path to the swipl pack search path
  postPatch = ''
    echo "user:file_search_path(pack, '$out/lib/swipl/extra-pack')." >> boot/init.pl
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    libarchive
    libxcrypt
    zlib
    openssl
    gperftools
    gmp
    readline
    libedit
  ] ++ optionalDependencies;

  hardeningDisable = [ "format" ];

  cmakeFlags =
    [ "-DSWIPL_INSTALL_IN_LIB=ON" ]
    ++ lib.optionals (!withNativeCompiler) [
      # without these options, the build will embed full compiler paths
      "-DSWIPL_CC=${if stdenv.hostPlatform.isDarwin then "clang" else "gcc"}"
      "-DSWIPL_CXX=${if stdenv.hostPlatform.isDarwin then "clang++" else "g++"}"
    ];

  preInstall = ''
    mkdir -p $out/lib/swipl/extra-pack
  '';

  postInstall = builtins.concatStringsSep "\n" (builtins.map (packInstall "$out") extraPacks);

  meta = {
    homepage = "https://www.swi-prolog.org";
    description = "Prolog compiler and interpreter";
    license = lib.licenses.bsd2;
    mainProgram = "swipl";
    platforms = lib.platforms.linux ++ lib.optionals (!withGui) lib.platforms.darwin;
    maintainers = [
      lib.maintainers.meditans
      lib.maintainers.matko
    ];
  };
}
