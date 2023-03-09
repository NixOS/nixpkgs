{ lib, stdenv, fetchFromGitHub, addOpenGLRunpath, cmake }:

stdenv.mkDerivation rec {
  pname = "level-zero";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "level-zero";
    rev = "v${version}";
    sha256 = "sha256-4AQnMMKo4BvajfhhKmhTZA0snKPnO4WjOuZAeiWU5PY=";
  };

  nativeBuildInputs = [ cmake addOpenGLRunpath ];

  postFixup = ''
    addOpenGLRunpath $out/lib/libze_loader.so
  '';

  meta = with lib; {
    description = "oneAPI Level Zero Specification Headers and Loader";
    homepage = "https://github.com/oneapi-src/level-zero";
    license = licenses.mit;
    maintainers = [ maintainers.ziguana ];
  };
}

