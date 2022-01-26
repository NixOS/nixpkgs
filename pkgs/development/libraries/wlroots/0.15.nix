{ lib, stdenv, fetchFromGitLab, meson, ninja, pkg-config, wayland-scanner
, libGL, wayland, wayland-protocols, libinput, libxkbcommon, pixman
, xcbutilwm, libX11, libcap, xcbutilimage, xcbutilerrors, mesa
, libpng, ffmpeg, xcbutilrenderutil, seatd, vulkan-loader, glslang
, nixosTests

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

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner glslang ];

  buildInputs = [
    libGL wayland wayland-protocols libinput libxkbcommon pixman
    xcbutilwm libX11 libcap xcbutilimage xcbutilerrors mesa
    libpng ffmpeg xcbutilrenderutil seatd vulkan-loader
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

  # Test via TinyWL (the "minimum viable product" Wayland compositor based on wlroots):
  passthru.tests.tinywl = nixosTests.tinywl;

  meta = with lib; {
    description = "A modular Wayland compositor library";
    longDescription = ''
      Pluggable, composable, unopinionated modules for building a Wayland
      compositor; or about 50,000 lines of code you were going to write anyway.
    '';
    inherit (src.meta) homepage;
    changelog = "https://gitlab.freedesktop.org/wlroots/wlroots/-/tags/${version}";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}
