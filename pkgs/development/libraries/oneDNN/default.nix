{ stdenv, lib, fetchFromGitHub, cmake }:

# This was originally called mkl-dnn, then it was renamed to dnnl, and it has
# just recently been renamed again to oneDNN. See here for details:
# https://github.com/oneapi-src/oneDNN#oneapi-deep-neural-network-library-onednn
stdenv.mkDerivation rec {
  pname = "oneDNN";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneDNN";
    rev = "v${version}";
    sha256 = "sha256-HBCuSZkApd/6UkAxz/KDFb/gyX2SI1S2GwgXAXSTU/c=";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ cmake ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = with lib; {
    description = "oneAPI Deep Neural Network Library (oneDNN)";
    homepage = "https://01.org/oneDNN";
    changelog = "https://github.com/oneapi-src/oneDNN/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ alexarice bhipple ];
  };
}
