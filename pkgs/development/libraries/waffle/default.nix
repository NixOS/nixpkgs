{ stdenv
, fetchFromGitLab
, lib
, meson
, ninja
, libGL
, libglvnd ? null
, makeWrapper
, pkg-config
, python3
, x11Support ? true, libxcb ? null, libX11 ? null
, waylandSupport ? true, wayland ? null
, useGbm ? true, mesa ? null, libudev ? null
}:

assert x11Support -> (libxcb != null && libX11 != null);
assert waylandSupport -> wayland != null;
assert useGbm -> (mesa != null && libudev != null);
assert with stdenv.hostPlatform; isUnix && !isDarwin -> libglvnd != null;

stdenv.mkDerivation rec {
  pname = "waffle";
  version = "1.6.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = "waffle";
    rev = "v${version}";
    sha256 = "0s8gislmhccfa04zsj1yqk97lscbbnmxirr2zm4q3p8ybmpfhpqr";
  };

  buildInputs = [
    libGL
  ] ++ stdenv.lib.optionals (with stdenv.hostPlatform; isUnix && !isDarwin) [
    libglvnd
  ] ++ stdenv.lib.optionals x11Support [
    libX11
    libxcb
  ] ++ stdenv.lib.optionals waylandSupport [
    wayland
  ] ++ stdenv.lib.optionals useGbm [
    mesa
    libudev
  ];

  nativeBuildInputs = [
    meson
    ninja
    makeWrapper
    pkg-config
    python3
  ];

  postInstall = ''
    wrapProgram $out/bin/wflinfo \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ libGL libglvnd ]}
  '';

  meta = with lib; {
    description = "A cross-platform C library that allows one to defer selection of an OpenGL API and window system until runtime";
    homepage = "http://www.waffle-gl.org/";
    license = licenses.bsd2;
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ Flakebi ];
  };
}
