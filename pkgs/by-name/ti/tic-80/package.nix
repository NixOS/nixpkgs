{ lib
, pkgs
, stdenv
, fetchFromGitHub
, libGL
, alsa-lib
, libX11
, xorgproto
, libICE
, libXi
, libXScrnSaver
, libXcursor
, libXinerama
, libXext
, libXxf86vm
, libXrandr
, libxkbcommon
, wayland
, wayland-protocols
, wayland-scanner
, dbus
, udev
, libdecor
, pipewire
, libpulseaudio
, libiconv
, ...
}:
with pkgs;
stdenv.mkDerivation rec {
  pname = "tic-80";
  version = "1.1.2837";

  src = fetchFromGitHub {
    owner = "nesbox";
    repo = "TIC-80";
    rev = "v" + version;
    sha256 = "sha256-2hSaLWw57F19tSfgJvBgbqW52vCu8p/TmoybYzQEybE=";
    fetchSubmodules = true;
    leaveDotGit = true; # Required for TIC-80's version detection via CMake.
  };

  # To avoid the awkward copyright range of "2017-1980", which would be caused by the
  # sandbox environment, hardcode the year of the release.
  postUnpack = ''
    YEAR_OF_LAST_COMMIT=$(git -C source log -1 --format=%ad --date=format:%Y)
    sed -E -i \
      -e "s|string\(TIMESTAMP VERSION_YEAR \"%Y\"\)|set(VERSION_YEAR \"$YEAR_OF_LAST_COMMIT\")|" \
      "source/CMakeLists.txt"
  '';

  # Taken from pkgs/development/compilers/mruby; necessary so it uses `gcc` instead of `ld` for linking.
  # https://github.com/mruby/mruby/blob/e502fd88b988b0a8d9f31b928eb322eae269c45a/tasks/toolchains/gcc.rake#L30
  preBuild = "unset LD";

  cmakeFlags = [ "-DBUILD_PRO=On" "-DBUILD_SDLGPU=On" ];
  enableParallelBuilding = true;
  dontStrip = true;
  buildInputs = [
    cmake
    pkg-config
    wayland-protocols
    python3
    ruby
    rake
    git
  ] ++ dlopenBuildInputs;
  dlopenBuildInputs = [
    libGL
    libGLU
    alsa-lib
    libX11
    libICE
    libXi
    libXScrnSaver
    libXcursor
    libXinerama
    libXext
    libXxf86vm
    libXrandr
    wayland
    libxkbcommon
    wayland-scanner
    curl
    dbus
    udev
    libdecor
    pipewire
    libpulseaudio
  ];
  dlopenPropagatedBuildInputs = [ libGL libX11 ];
  propagatedBuildInputs = [ xorgproto ] ++ dlopenPropagatedBuildInputs;

  # This package borrows heavily from pkgs/development/libraries/SDL2/default.nix
  # because TIC-80 vendors SDL2, which means we need to take care and implemment
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
      rpath = lib.makeLibraryPath (dlopenPropagatedBuildInputs ++ dlopenBuildInputs);
    in
    ''
      patchelf --set-rpath "$(patchelf --print-rpath $out/bin/tic80):${rpath}" "$out/bin/tic80"
    '';

  meta = with lib; {
    description =
      "A free and open source fantasy computer for making, playing and sharing tiny games";
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
