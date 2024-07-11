{ lib
, addOpenGLRunpath
, cmake
, fetchFromGitHub
, intel-compute-runtime
, openvino
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "level-zero";
  version = "1.17.17";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "level-zero";
    rev = "refs/tags/v${version}";
    hash = "sha256-+8bIY/90dXsCdCMeoxL1+OK2Yhl4XNRI3RPuPouGWHc=";
  };

  nativeBuildInputs = [ cmake addOpenGLRunpath ];

  postFixup = ''
    addOpenGLRunpath $out/lib/libze_loader.so
  '';

  passthru.tests = {
    inherit intel-compute-runtime openvino;
  };

  meta = with lib; {
    description = "oneAPI Level Zero Specification Headers and Loader";
    homepage = "https://github.com/oneapi-src/level-zero";
    changelog = "https://github.com/oneapi-src/level-zero/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.ziguana ];
  };
}

