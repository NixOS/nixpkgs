<<<<<<< HEAD
{ cmake
, fetchFromGitHub
, lib
, stdenv
}:
=======
{ stdenv, lib, fetchFromGitHub, cmake }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

# This was originally called mkl-dnn, then it was renamed to dnnl, and it has
# just recently been renamed again to oneDNN. See here for details:
# https://github.com/oneapi-src/oneDNN#oneapi-deep-neural-network-library-onednn
<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "oneDNN";
  version = "3.2.1";
=======
stdenv.mkDerivation rec {
  pname = "oneDNN";
  version = "2.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneDNN";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-/LbT2nHPpZHjY3xbJ9bDabR7aIMvetNP4mB+rxuTfy8=";
=======
    rev = "v${version}";
    sha256 = "sha256-HBCuSZkApd/6UkAxz/KDFb/gyX2SI1S2GwgXAXSTU/c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ cmake ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  # Fixup bad cmake paths
  postInstall = ''
    substituteInPlace $out/lib/cmake/dnnl/dnnl-config.cmake \
      --replace "\''${PACKAGE_PREFIX_DIR}/" ""

    substituteInPlace $out/lib/cmake/dnnl/dnnl-targets.cmake \
      --replace "\''${_IMPORT_PREFIX}/" ""
  '';

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/oneapi-src/oneDNN/releases/tag/v${finalAttrs.version}";
    description = "oneAPI Deep Neural Network Library (oneDNN)";
    homepage = "https://01.org/oneDNN";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bhipple ];
    platforms = lib.platforms.all;
  };
})
=======
  meta = with lib; {
    description = "oneAPI Deep Neural Network Library (oneDNN)";
    homepage = "https://01.org/oneDNN";
    changelog = "https://github.com/oneapi-src/oneDNN/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ alexarice bhipple ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
