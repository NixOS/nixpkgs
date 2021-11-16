{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, wayland-scanner
, libGL, wayland, wayland-protocols, libinput, libxkbcommon, pixman
, xcbutilwm, libX11, libcap, xcbutilimage, xcbutilerrors, mesa
, libpng, ffmpeg, xcbutilrenderutil, seatd

, enableXWayland ? true, xwayland ? null
}:

stdenv.mkDerivation rec {
  pname = "wlroots";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "wlroots";
    rev = version;
    sha256 = "1sshp3lvlkl1i670kxhwsb4xzxl8raz6769kqvgmxzcb63ns9ay1";
  };

  # $out for the library and $examples for the example programs (in examples):
  outputs = [ "out" "examples" ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner ];

  buildInputs = [
    libGL wayland wayland-protocols libinput libxkbcommon pixman
    xcbutilwm libX11 libcap xcbutilimage xcbutilerrors mesa
    libpng ffmpeg xcbutilrenderutil seatd
  ]
    ++ lib.optional enableXWayland xwayland
  ;

  mesonFlags =
    lib.optional (!enableXWayland) "-Dxwayland=disabled"
  ;

  postFixup = ''
    # Install ALL example programs to $examples:
    # screencopy dmabuf-capture input-inhibitor layer-shell idle-inhibit idle
    # screenshot output-layout multi-pointer rotation tablet touch pointer
    # simple
    mkdir -p $examples/bin
    cd ./examples
    for binary in $(find . -executable -type f -printf '%P\n' | grep -vE '\.so'); do
      cp "$binary" "$examples/bin/wlroots-$binary"
    done
  '';

  meta = with lib; {
    description = "A modular Wayland compositor library";
    longDescription = ''
      Pluggable, composable, unopinionated modules for building a Wayland
      compositor; or about 50,000 lines of code you were going to write anyway.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/swaywm/wlroots/releases/tag/${version}";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}
