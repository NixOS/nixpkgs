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
  alsa-lib,
  libX11,
  libICE,
  libXi,
  libXScrnSaver,
  libXcursor,
  libXinerama,
  libXext,
  libXxf86vm,
  libXrandr,
  libxkbcommon,
  wayland,
  wayland-protocols,
  wayland-scanner,
  dbus,
  udev,
  libdecor,
  pipewire,
  libpulseaudio,
  # Whether to build TIC-80's "Pro" version, which is an incentive to support the project financially,
  # that enables some additional features. It is, however, fully open source.
  withPro ? false,
}:
let
  major = "1";
  minor = "1";
  revision = "2837";
  year = "2023";
in

stdenv.mkDerivation rec {
  pname = "tic-80";
  version = "${major}.${minor}.${revision}";

  src = fetchFromGitHub {
    owner = "nesbox";
    repo = "TIC-80";
    rev = "v" + version;
    hash = "sha256-p7OyuD/4KxAzylQDlXW681TvEZwKYDD4zq2KDRkcv48=";
    # TIC-80 vendors its dependencies as submodules, so to use its current build system,
    # we need to fetch them. Managing the dependencies ourselves would require a lot of
    # changes in the build system, which doesn't seem worth it right now. In future versions,
    # TIC-80 is switching to more modular CMake files, at which point we can reconsider.
    fetchSubmodules = true;
  };

  # TIC-80 tries to determine the revision part of the version using its Git history.
  # Because using leaveDotGit tends be non-reproducible with submodules, we just
  # hardcode it.
  # To avoid the awkward copyright range of "2017-1980", which would be caused by the
  # sandbox environment, hardcode the year of the release.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(VERSION_REVISION 0)' 'set(VERSION_REVISION ${revision})' \
      --replace-fail 'string(TIMESTAMP VERSION_YEAR "%Y")' 'set(VERSION_YEAR "${year}")'
  '';

  # Taken from pkgs/development/compilers/mruby; necessary so it uses `gcc` instead of `ld` for linking.
  # https://github.com/mruby/mruby/blob/e502fd88b988b0a8d9f31b928eb322eae269c45a/tasks/toolchains/gcc.rake#L30
  preBuild = ''
    unset LD
  '';

  cmakeFlags = lib.optionals withPro [ "-DBUILD_PRO=On" ] ++ [ "-DBUILD_SDLGPU=On" ];
  nativeBuildInputs = [
    cmake
    curl
    pkg-config
    python3
    rake
  ];
  buildInputs = [
    alsa-lib
    dbus
    libdecor
    libGL
    libGLU
    libICE
    libpulseaudio
    libX11
    libXcursor
    libXext
    libXi
    libXinerama
    libxkbcommon
    libXrandr
    libXScrnSaver
    libXxf86vm
    pipewire
    udev
    wayland
    wayland-protocols
    wayland-scanner
  ];

  # This package borrows heavily from pkgs/development/libraries/SDL2/default.nix
  # because TIC-80 vendors SDL2, which means we need to take care and implement
  # a similar environment in TIC-80's vendored copy of SDL2.
  #
  # SDL is weird in that instead of just dynamically linking with
  # libraries when you `--enable-*` (or when `configure` finds) them
  # it `dlopen`s them at runtime. In principle, this means it can
  # ignore any missing optional dependencies like alsa, pulseaudio,
  # some x11 libs, wayland, etc if they are missing on the system
  # and/or work with wide array of versions of said libraries. In
  # nixpkgs, however, we don't need any of that. Moreover, since we
  # don't have a global ld-cache we have to stuff all the propagated
  # libraries into rpath by hand or else some applications that use
  # SDL API that requires said libraries will fail to start.
  #
  # You can grep SDL sources with `grep -rE 'SDL_(NAME|.*_SYM)'` to
  # list the symbols used in this way.
  postFixup =
    let
      rpath = lib.makeLibraryPath buildInputs;
    in
    ''
      patchelf --set-rpath "$(patchelf --print-rpath $out/bin/tic80):${rpath}" "$out/bin/tic80"
    '';

  meta = with lib; {
    description = "A free and open source fantasy computer for making, playing and sharing tiny games";
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
