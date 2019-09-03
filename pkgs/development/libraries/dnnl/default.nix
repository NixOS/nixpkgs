{ stdenv, lib, fetchFromGitHub, cmake, substituteAll, bash, autoPatchelfHook, mkl ? null }:

stdenv.mkDerivation rec {
  pname = "dnnl";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "mkl-dnn";
    rev = "v${version}";
    sha256 = "0lf14a4j511pydyz78wwbl6hifbq86m3dy119iss9cvz8zzrdyvw";
  };
  outputs = [ "out" "dev" "doc" ];
  patches = [ (substituteAll {
    src = ./bash-to-sh.patch;
    inherit bash;
  }) ];

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional (mkl != null) mkl;

  doCheck = true;

  # the test executables aren't able to find libmkldnn.so through LD_LIBRARY_PATH, so patch them.
  checkInputs = [ autoPatchelfHook ];
  preCheck = ''
    addAutoPatchelfSearchPath $PWD/src
    autoPatchelf tests examples
  '';

  meta = with lib; {
    description = "Deep Neural Network Library (DNNL)";
    homepage = "https://intel.github.io/mkl-dnn/dev_guide_transition_to_dnnl.html";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ alexarice ];
  };
}
