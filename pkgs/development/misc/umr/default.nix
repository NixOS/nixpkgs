{ lib, stdenv, fetchgit, bash-completion, cmake, pkg-config
, json_c, libdrm, libpciaccess, llvmPackages, nanomsg, ncurses, SDL2
}:

stdenv.mkDerivation rec {
  pname = "umr";
  version = "unstable-2022-08-23";

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/tomstdenis/umr";
    rev = "87f814b1ffdbac8bfddd8529d344a7901cd7e112";
    hash = "sha256-U1VP1AicSGWzBwzz99i7+3awATZocw5jaqtAxuRNaBE=";
  };

  nativeBuildInputs = [ cmake pkg-config llvmPackages.llvm.dev ];

  buildInputs = [
    bash-completion
    json_c
    libdrm
    libpciaccess
    llvmPackages.llvm
    nanomsg
    ncurses
    SDL2
  ];

  # Remove static libraries (there are no dynamic libraries in there)
  postInstall = ''
    rm -r $out/lib
  '';

  meta = with lib; {
    description = "A userspace debugging and diagnostic tool for AMD GPUs";
    homepage = "https://gitlab.freedesktop.org/tomstdenis/umr";
    license = licenses.mit;
    maintainers = with maintainers; [ Flakebi ];
    platforms = platforms.linux;
 };
}
