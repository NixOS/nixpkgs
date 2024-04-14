{ cmake
, fetchFromGitHub
, lib
, stdenv
}:

# This was originally called mkl-dnn, then it was renamed to dnnl, and it has
# just recently been renamed again to oneDNN. See here for details:
# https://github.com/oneapi-src/oneDNN#oneapi-deep-neural-network-library-onednn
stdenv.mkDerivation (finalAttrs: {
  pname = "oneDNN";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneDNN";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6iPcytsRWvDn2hg5tkSG6A3cv/aOhmEVd5rS2uOKCPk=";
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

  meta = {
    changelog = "https://github.com/oneapi-src/oneDNN/releases/tag/v${finalAttrs.version}";
    description = "oneAPI Deep Neural Network Library (oneDNN)";
    homepage = "https://01.org/oneDNN";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bhipple ];
    platforms = lib.platforms.all;
  };
})
