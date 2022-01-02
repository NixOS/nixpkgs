{ lib
, stdenv
, fetchFromGitLab
, ffmpeg
, glslang
, libGL
, libX11
, libcap
, libinput
, libpng
, libxkbcommon
, mesa
, meson
, ninja
, pixman
, pkg-config
, seatd
, vulkan-loader
, wayland
, wayland-protocols
, wayland-scanner
, xcbutilerrors
, xcbutilimage
, xcbutilrenderutil
, xcbutilwm

, enableXWayland ? true, xwayland ? null
}:

stdenv.mkDerivation rec {
  pname = "wlroots";
  version = "0.15.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wlroots";
    repo = "wlroots";
    rev = version;
    sha256 = "0wdzs0wpv61pxgy3mx3xjsndyfmbj30v47d3w9ymmnd4r479n41n";
  };

  # $out for the library and $examples for the example programs (in examples):
  outputs = [ "out" "examples" ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    ffmpeg
    libGL
    libX11
    libcap
    libinput
    libpng
    libxkbcommon
    mesa
    pixman
    seatd
    vulkan-loader glslang
    wayland
    wayland-protocols
    xcbutilerrors
    xcbutilimage
    xcbutilrenderutil
    xcbutilwm
  ]
  ++ lib.optional enableXWayland xwayland;

  mesonFlags = lib.optional (!enableXWayland) "-Dxwayland=disabled";

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
    inherit (src.meta) homepage;
    description = "A modular Wayland compositor library";
    longDescription = ''
      Pluggable, composable, unopinionated modules for building a Wayland
      compositor; or about 50,000 lines of code you were going to write anyway.
    '';
    changelog = "https://gitlab.freedesktop.org/wlroots/wlroots/-/tags/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ primeos synthetica ];
    inherit (wayland.meta) platforms;
  };
}
