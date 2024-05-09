{ lib
, addOpenGLRunpath
, cmake
, fetchFromGitHub
, fmt_9
, spdlog
, stdenv
, substituteAll
}:

stdenv.mkDerivation rec {
  pname = "level-zero";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "level-zero";
    rev = "refs/tags/v${version}";
    hash = "sha256-wI7moyxuU84TLPmle8tzt/4ZY48DG+EWuyL1WjtJREM=";
  };

  patches = [
    (substituteAll {
      src = ./system-spdlog.diff;
      spdlog = lib.getDev spdlog;
    })
  ];

  nativeBuildInputs = [ cmake addOpenGLRunpath ];

  buildInputs = [ fmt_9 ];

  postFixup = ''
    addOpenGLRunpath $out/lib/libze_loader.so
  '';

  meta = with lib; {
    description = "oneAPI Level Zero Specification Headers and Loader";
    homepage = "https://github.com/oneapi-src/level-zero";
    changelog = "https://github.com/oneapi-src/level-zero/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.ziguana ];
  };
}

