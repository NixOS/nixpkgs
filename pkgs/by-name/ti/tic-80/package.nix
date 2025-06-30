{
  lib,
  stdenv,
  cmake,
  pkg-config,
  python3,
  rake,
  curl,
  fetchFromGitHub,
  libGL,
  libGLU,
  libX11,
  janet,
  lua5_3,
  quickjs,
  SDL2,
  # Whether to build TIC-80's "Pro" version, which is an incentive to support the project financially,
  # that enables some additional features. It is, however, fully open source.
  withPro ? false,
}:
let
  # git rev-list HEAD --count
  revision = "3016";
  year = "2025";
in

stdenv.mkDerivation {
  pname = "tic-80";
  # use an untagged version until upstream tags a new version. We want
  # 'PREFER_SYSTEM_LIBRARIES', and without it tic-80 won't build
  version = "1.1-unstable-2025-05-26";

  src = fetchFromGitHub {
    owner = "nesbox";
    repo = "TIC-80";
    rev = "663d43924abf6fd7620de6bf25c009ce5b30ab83";
    hash = "sha256-UjBnXxYZ5gfk58sI1qek5fkKpJ7LzOVmrxdjVgONcXc=";
    # TIC-80 vendors its dependencies as submodules. For the following dependencies,
    # there are no (or no compatible) packages in nixpkgs yet, so we use the vendored
    # ones as a fill-in: kubazip, wasm, squirrel, pocketpy, argparse, naett,
    # sdlgpu, mruby.
    fetchSubmodules = true;
  };

  # TIC-80 tries to determine the revision part of the version using its Git history.
  # Because using leaveDotGit tends be non-reproducible with submodules, we just
  # hardcode it.
  # To avoid the awkward copyright range of "2017-1980", which would be caused by the
  # sandbox environment, hardcode the year of the release.
  postPatch = ''
    substituteInPlace cmake/version.cmake \
      --replace-fail 'set(VERSION_REVISION 0)' 'set(VERSION_REVISION ${revision})' \
      --replace-fail 'string(TIMESTAMP VERSION_YEAR "%Y")' 'set(VERSION_YEAR "${year}")'
  '';

  # Taken from pkgs/development/compilers/mruby; necessary so it uses `gcc` instead of `ld` for linking.
  # https://github.com/mruby/mruby/blob/e502fd88b988b0a8d9f31b928eb322eae269c45a/tasks/toolchains/gcc.rake#L30
  preBuild = ''
    unset LD
  '';

  cmakeFlags =
    let
      enableCmakeBool = (lib.flip lib.cmakeBool) true;
    in
    [
      (lib.cmakeBool "BUILD_PRO" withPro)
    ]
    ++ (map enableCmakeBool [
      "BUILD_STATIC"
      "PREFER_SYSTEM_LIBRARIES"
      "BUILD_SDLGPU"
      "BUILD_WITH_ALL"
    ]);

  nativeBuildInputs = [
    cmake
    curl
    pkg-config
    python3
    rake
  ];
  buildInputs = [
    libGL
    libGLU
    libX11
    janet
    (lua5_3.withPackages (ps: [ ps.fennel ]))
    quickjs
    SDL2
  ];

  meta = with lib; {
    description = "Free and open source fantasy computer for making, playing and sharing tiny games";
    longDescription = ''
      TIC-80 is a free and open source fantasy computer for making, playing and
      sharing tiny games.

      There are built-in tools for development: code, sprites, maps, sound
      editors and the command line, which is enough to create a mini retro
      game. At the exit you will get a cartridge file, which can be stored and
      played on the website.

      Also, the game can be packed into a player that works on all popular
      platforms and distribute as you wish. To make a retro styled game the
      whole process of creation takes place under some technical limitations:
      240x136 pixels display, 16 color palette, 256 8x8 color sprites, 4
      channel sound and etc.
    '';
    homepage = "https://github.com/nesbox/TIC-80";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "tic80";
    maintainers = with maintainers; [ blinry ];
  };
}
