{ lib, stdenv, fetchgit, bash-completion, cmake, pkg-config
, libdrm, libpciaccess, llvmPackages, ncurses
}:

stdenv.mkDerivation rec {
  pname = "umr";
  version = "unstable-2021-02-18";

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/tomstdenis/umr";
    rev = "79e17f8f2807ed707fc1be369d0aad536f6dbc97";
    sha256 = "IwTkHEuJ82hngPjFVIihU2rSolLBqHxQTNsP8puYPaY=";
  };

  nativeBuildInputs = [ cmake pkg-config llvmPackages.llvm.dev ];

  buildInputs = [
    bash-completion
    libdrm
    libpciaccess
    llvmPackages.llvm
    ncurses
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
