{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  scdoc,
  libgbm,
  lz4,
  zstd,
  ffmpeg,
  libva,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation rec {
  pname = "waypipe";
  version = "0.9.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mstoeckl";
    repo = "waypipe";
    rev = "v${version}";
    hash = "sha256-DW+WWwuav0lxnoV55L8RrX0enRURRnHMljtwEC0+9t4=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];
  buildInputs = [
    # Optional dependencies:
    libgbm
    lz4
    zstd
    ffmpeg
    libva

    wayland
  ];

  meta = with lib; {
    description = "Network proxy for Wayland clients (applications)";
    longDescription = ''
      waypipe is a proxy for Wayland clients. It forwards Wayland messages and
      serializes changes to shared memory buffers over a single socket. This
      makes application forwarding similar to ssh -X feasible.
    '';
    homepage = "https://mstoeckl.com/notes/gsoc/blog.html";
    changelog = "https://gitlab.freedesktop.org/mstoeckl/waypipe/-/releases#v${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 ];
    mainProgram = "waypipe";
  };
}
