{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "epoll-shim";
  version = "unstable-2023-02-05";

  src = fetchFromGitHub {
    owner = "jiixyj";
    repo = finalAttrs.pname;
    rev = "702e845d7850e30a7b9e29f759c9c8f7bb40784b";
    hash = "sha256-QfBnF0/P2KjQggEdJCdqVJDeV/+iaN0OZIwIGyIyr68=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PKGCONFIGDIR=${placeholder "out"}/lib/pkgconfig"
    "-DBUILD_TESTING=${lib.boolToString finalAttrs.doCheck}"
  ];

  # https://github.com/jiixyj/epoll-shim/issues/41
  # https://github.com/jiixyj/epoll-shim/pull/34
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Small epoll implementation using kqueue";
    homepage = "https://github.com/jiixyj/epoll-shim";
    license = licenses.mit;
    platforms = platforms.darwin ++ platforms.freebsd ++ platforms.netbsd ++ platforms.openbsd;
    maintainers = with maintainers; [ wegank ];
  };
})
