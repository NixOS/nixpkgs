{ stdenv, lib, fetchFromGitHub, substituteAll, cmake, bash }:

stdenv.mkDerivation rec {
  pname = "dnnl";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "mkl-dnn";
    rev = "v${version}";
    sha256 = "150cdyfiw4izvzmbmdqidwadppb1qjmzhpaqjczm397ygi1m92l1";
  };

  # Generic fix upstreamed in https://github.com/intel/mkl-dnn/pull/631
  # Delete patch when 1.2.0 is released
  patches = [ (substituteAll {
    src = ./bash-to-sh.patch;
    inherit bash;
  }) ];

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ cmake ];

  # The test driver doesn't add an RPath to the build libdir
  preCheck = ''
    export LD_LIBRARY_PATH=$PWD/src
  '';

  doCheck = true;

  meta = with lib; {
    description = "Deep Neural Network Library (DNNL)";
    homepage = "https://intel.github.io/mkl-dnn/dev_guide_transition_to_dnnl.html";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ alexarice bhipple ];
  };
}
