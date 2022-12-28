{ lib, stdenv, fetchFromGitHub, addOpenGLRunpath, cmake }:

stdenv.mkDerivation rec {
  pname = "level-zero";
  version = "1.8.12";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "level-zero";
    rev = "v${version}";
    sha256 = "sha256-87fnucPg8JygYo3QSuA6ll0acbHQvmWzNLEp4dqkAH8=";
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

