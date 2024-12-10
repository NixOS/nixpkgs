{ lib
, stdenv

, fetchFromGitLab

, cmake
, pkg-config

, libdrm
, mesa # libgbm
, libpciaccess
, llvmPackages
, nanomsg
, ncurses
, SDL2
, bash-completion

, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "umr";
  version = "1.0.10";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "tomstdenis";
    repo = "umr";
    rev = version;
    hash = "sha256-i0pTcg1Y+G/nGZSbMtlg37z12gF4heitEl5L4gfVO9c=";
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Userspace debugging and diagnostic tool for AMD GPUs";
    homepage = "https://gitlab.freedesktop.org/tomstdenis/umr";
    license = licenses.mit;
    maintainers = with maintainers; [ Flakebi ];
    platforms = platforms.linux;
 };
}
