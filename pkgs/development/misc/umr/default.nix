{
  lib,
  stdenv,

  fetchFromGitLab,

  cmake,
  pkg-config,

  libdrm,
  mesa, # libgbm
  libpciaccess,
  llvmPackages,
  nanomsg,
  ncurses,
  SDL2,
  bash-completion,

  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "umr";
  version = "1.0.8";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "tomstdenis";
    repo = "umr";
    rev = version;
    hash = "sha256-ODkTYHDrKWNvjiEeIyfsCByf7hyr5Ps9ytbKb3253bU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libdrm
    mesa
    libpciaccess
    llvmPackages.llvm
    nanomsg
    ncurses
    SDL2

    bash-completion # Tries to create bash-completions in /var/empty otherwise?
  ];

  # Remove static libraries (there are no dynamic libraries in there)
  postInstall = ''
    rm -r $out/lib
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Userspace debugging and diagnostic tool for AMD GPUs";
    homepage = "https://gitlab.freedesktop.org/tomstdenis/umr";
    license = licenses.mit;
    maintainers = with maintainers; [ Flakebi ];
    platforms = platforms.linux;
  };
}
