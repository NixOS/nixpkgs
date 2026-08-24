{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "Vc";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "VcDevel";
    repo = "Vc";
    rev = finalAttrs.version;
    sha256 = "sha256-A2qUzjXv50unFcoZp2nRVinkph+CoHyiU7AgOphDphM=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    sed -i '/OptimizeForArchitecture()/d' cmake/VcMacros.cmake
    sed -i '/AutodetectHostArchitecture()/d' print_target_architecture.cmake
  '';

  meta = {
    description = "Library for multiprecision complex arithmetic with exact rounding";
    homepage = "https://github.com/VcDevel/Vc";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
