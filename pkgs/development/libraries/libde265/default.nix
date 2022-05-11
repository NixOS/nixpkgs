{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  version = "1.0.8";
  pname = "libde265";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libde265";
    rev = "v${version}";
    sha256 = "1dzflqbk248lz5ws0ni5acmf32b3rmnq5gsfaz7691qqjxkl1zml";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-1253.patch";
      url = "https://github.com/strukturag/libde265/commit/8e89fe0e175d2870c39486fdd09250b230ec10b8.patch";
      sha256 = "sha256-F1BOWFx9oXR2trM22atyD3AJ5x6vVfURQ/PTlYP2Ibg=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/strukturag/libde265";
    description = "Open h.265 video codec implementation";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gebner ];
  };
}
