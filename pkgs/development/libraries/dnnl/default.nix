{ stdenv, lib, fetchFromGitHub, substituteAll, cmake, bash }:

# This was originally called mkl-dnn, then it was renamed to dnnl, and it has
# just recently been renamed again to oneDNN. In a follow-up, let's move the
# attr and alias dnnl -> oneDNN. See here for details:
# https://github.com/oneapi-src/oneDNN#oneapi-deep-neural-network-library-onednn
stdenv.mkDerivation rec {
  pname = "dnnl";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneDNN";
    rev = "v${version}";
    sha256 = "162fb0c7klahz2irchhyxympi4fq4yp284apc53cadbss41mzld9";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  # The test driver doesn't add an RPath to the build libdir
  preCheck = ''
    export LD_LIBRARY_PATH=$PWD/src
  '';

  # The cmake install gets tripped up and installs a nix tree into $out, in
  # addition to the correct install; clean it up.
  postInstall = ''
    rm -r $out/nix
  '';

  meta = with lib; {
    description = "oneAPI Deep Neural Network Library (oneDNN)";
    homepage = "https://01.org/dnnl";
    changelog = "https://github.com/oneapi-src/oneDNN/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ alexarice bhipple ];
  };
}
