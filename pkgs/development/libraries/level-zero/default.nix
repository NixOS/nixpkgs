{ lib, stdenv, fetchFromGitHub, addOpenGLRunpath, cmake }:

stdenv.mkDerivation rec {
  pname = "level-zero";
  version = "1.8.8";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "level-zero";
    rev = "v${version}";
    sha256 = "sha256-hfbTgEbvrhWkZEi8Km7KaxJBAc9X1kA/T2DLooKa7KQ=";
  };

  nativeBuildInputs = [ cmake addOpenGLRunpath ];

  postFixup = ''
    addOpenGLRunpath $out/lib/libze_loader.so
  '';

  meta = with lib; {
    homepage = "https://www.oneapi.io/";
    description = "oneAPI Level Zero Specification Headers and Loader";
    license = licenses.mit;
    maintainers = [ maintainers.ziguana ];
  };
}

