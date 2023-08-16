{ lib
, stdenv
, fetchFromGitHub
, addOpenGLRunpath
, cmake
}:

stdenv.mkDerivation rec {
  pname = "level-zero";
  version = "1.13.5";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "level-zero";
    rev = "refs/tags/v${version}";
    hash = "sha256-XpLbbcB8M63q+0Vj7NrERSXVIjy5KQrVZMvYijUbJhw=";
  };

  nativeBuildInputs = [ cmake addOpenGLRunpath ];

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

