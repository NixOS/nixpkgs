{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "epoll-shim";
  version = "0.0.20230411";

  src = fetchFromGitHub {
    owner = "jiixyj";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-TOfybtUEp+EtY2l/UGwVFIESDe9kELJCZHlcz22Cmi8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PKGCONFIGDIR=${placeholder "out"}/lib/pkgconfig"
    "-DBUILD_TESTING=${lib.boolToString finalAttrs.finalPackage.doCheck}"
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
