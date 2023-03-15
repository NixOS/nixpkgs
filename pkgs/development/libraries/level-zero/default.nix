{ lib, stdenv, fetchFromGitHub, addOpenGLRunpath, cmake }:

stdenv.mkDerivation rec {
  pname = "level-zero";
  version = "1.9.9";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "level-zero";
    rev = "v${version}";
    sha256 = "sha256-zzlecBk7Mi3Nhj4eIAp81pq7+lIiKpvEaNeXuJKDPII=";
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

