{
  stdenv,
  fetchFromGitLab,
  lib,
  cmake,
  meson,
  ninja,
  bash-completion,
  libGL,
  libglvnd,
  makeWrapper,
  pkg-config,
  python3,
  x11Support ? true,
  libxcb,
  libX11,
  waylandSupport ? true,
  wayland,
  wayland-protocols,
  wayland-scanner,
  useGbm ? true,
  mesa,
  udev,
}:

stdenv.mkDerivation rec {
  pname = "waffle";
  version = "1.8.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = "waffle";
    rev = "v${version}";
    sha256 = "sha256-Y7GRYLqSO572qA1eZ3jS8QlZ1X9xKpDtScaySTuPK/U=";
  };

  buildInputs =
    [
      bash-completion
      libGL
    ]
    ++ lib.optionals (with stdenv.hostPlatform; isUnix && !isDarwin) [
      libglvnd
    ]
    ++ lib.optionals x11Support [
      libX11
      libxcb
    ]
    ++ lib.optionals waylandSupport [
      wayland
      wayland-protocols
    ]
    ++ lib.optionals useGbm [
      udev
      mesa
    ];

  depsBuildBuild = [ pkg-config ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs =
    [
      cmake
      makeWrapper
      meson
      ninja
      pkg-config
      python3
    ]
    ++ lib.optionals waylandSupport [
      wayland-scanner
    ];

  PKG_CONFIG_BASH_COMPLETION_COMPLETIONSDIR = "${placeholder "out"}/share/bash-completion/completions";

  postInstall = ''
    wrapProgram $out/bin/wflinfo \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          libglvnd
        ]
      }
  '';

  meta = with lib; {
    description = "Cross-platform C library that allows one to defer selection of an OpenGL API and window system until runtime";
    mainProgram = "wflinfo";
    homepage = "https://www.waffle-gl.org/";
    license = licenses.bsd2;
    inherit (mesa.meta) platforms;
    maintainers = with maintainers; [ Flakebi ];
  };
}
