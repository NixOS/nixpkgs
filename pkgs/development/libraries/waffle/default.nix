{ stdenv
, fetchFromGitLab
, lib
, cmake
, meson
, ninja
, bash-completion
, libGL
, libglvnd
, makeWrapper
, pkg-config
, python3
, x11Support ? true, libxcb, libX11
, waylandSupport ? true, wayland, wayland-protocols
, useGbm ? true, mesa, udev
}:

stdenv.mkDerivation rec {
  pname = "waffle";
  version = "1.7.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = "waffle";
    rev = "v${version}";
    sha256 = "iY+dAgXutD/uDFocwd9QXjq502IOsk+3RQMA2S/CMV4=";
  };

  buildInputs = [
    bash-completion
    libGL
  ] ++ lib.optionals (with stdenv.hostPlatform; isUnix && !isDarwin) [
    libglvnd
  ] ++ lib.optionals x11Support [
    libX11
    libxcb
  ] ++ lib.optionals waylandSupport [
    wayland
    wayland-protocols
  ] ++ lib.optionals useGbm [
    udev
    mesa
  ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    meson
    ninja
    pkg-config
    python3
  ];

  PKG_CONFIG_BASH_COMPLETION_COMPLETIONSDIR= "${placeholder "out"}/share/bash-completion/completions";

  postInstall = ''
    wrapProgram $out/bin/wflinfo \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL libglvnd ]}
  '';

  meta = with lib; {
    description = "A cross-platform C library that allows one to defer selection of an OpenGL API and window system until runtime";
    homepage = "http://www.waffle-gl.org/";
    license = licenses.bsd2;
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ Flakebi ];
  };
}
