{ stdenv, lib, fetchFromGitHub, substituteAll, cmake, bash }:

stdenv.mkDerivation rec {
  pname = "dnnl";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "mkl-dnn";
    rev = "v${version}";
    sha256 = "17bydid5v43lgwvgxv25i67iiyirmwgbdzvv9wpjig34ryhx8hvf";
  };

  # Generic fix merged upstream in https://github.com/intel/mkl-dnn/pull/631
  # Delete after next release
  patches = [ (substituteAll {
    src = ./bash-to-sh.patch;
    inherit bash;
  }) ];

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
    description = "Deep Neural Network Library (DNNL)";
    homepage = "https://intel.github.io/mkl-dnn/dev_guide_transition_to_dnnl.html";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ alexarice bhipple ];
  };
}
